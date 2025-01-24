const express = require('express');
const { createServer } = require('node:http');
const { join } = require('node:path');
const { Server } = require('socket.io');
const cors = require('cors');

const SERVER_ADDRESS = '0.0.0.0';
const SERVER_PORT = 9001;
const app = express();
const server = createServer(app);

const corsOptions = {
    origin: '*',
    optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));
app.use(express.static('static'))

app.get('/', (_req, res) => {
    res.sendFile(join(__dirname, 'html', 'index.html'));
});

const io = new Server(server, {
    cors: {
        origin: '*',
        methods: ['GET'],
        credentials: false,
    },
});


// Which socket ids are associated to which roles.
const roles = new Map();

// Which users are controlling the slides.
const activeSockets = {
    master: null,
    follower: null,
};

const roleKeys = ['master', 'follower'];

const handleRegister = (socket, role) => {
    role = role.toLowerCase();

    if (!roleKeys.includes(role)) {
        console.error(`Invalid role key: "${role}".`);
        return;
    }

    if (!activeSockets[role])
        activeSockets[role] = socket;

    roles.set(socket.id, role);
};

const handleControl = (socket) => {
    if (!roles.get(socket.id, 'master')) {
        console.error('This user cannot take remote control.');
        return;
    }

    activeSockets.master = socket;
};

const handleDisconnect = (socket) => {
    const role = roles.get(socket.id);

    if (!role) {
        console.info('Guest user disconnected.');
        return;
    }

    if (activeSockets[role] && activeSockets[role].id === socket.id) {
        activeSockets[role] = null;
        roles.delete(socket.id);
        console.info(`User "${role}" disconnected:`);
    }
};

const isActive = (socket, targetRole) => {
    const role = roles.get(socket.id);

    if (!role || role !== targetRole)
        return false;

    return socket.id === activeSockets[role]?.id
};

const getStatus = (socket) => {
    return JSON.stringify({
        type: 'STATUS',
        isActiveMaster: isActive(socket, 'master'),
        isActiveFollower: isActive(socket, 'follower'),
        role: roles.get(socket.id),
    });
};

const broadcastStatus = () => {
    io.fetchSockets().then((sockets) => {
        for (const socket of sockets) {
            const status = getStatus(socket);
            socket.send(status);
        }
    });
}

// Socket.io connection event.
io.on('connection', (socket) => {
    socket.on('register', (message) => {
        handleRegister(socket, message.role);
        broadcastStatus();
    });

    socket.on('control', (_message) => {
        handleControl(socket);
        broadcastStatus();
    });

    socket.on('action', (message) => {
        if (!isActive(socket, 'master')) {
            socket.send(JSON.stringify({
                type: 'ERROR',
                reason: 'NOT_ACTIVE_CONTROLLER',
                message: 'You are not an active controller.',
            }));

            return;
        }

        const followerSocket = activeSockets['follower'];

        if (!followerSocket) {
            console.warn('No active followers.');
            return;
        }

        followerSocket.emit('action', { action: message.action });
    });

    socket.on('disconnect', () => {
        handleDisconnect(socket);
    });
});

server.listen(SERVER_PORT, SERVER_ADDRESS, () => {
    console.info(`Controller server listening on http://${SERVER_ADDRESS}:${SERVER_PORT}.`);
});
