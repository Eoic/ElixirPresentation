const express = require('express');
const { createServer } = require('node:http');
const { join } = require('node:path');
const { Server } = require('socket.io');
const os = require('os');
const cors = require('cors');

const SERVER_ADDRESS = '0.0.0.0';
const SERVER_PORT = 9001;
const ips = os.networkInterfaces();

let ip = SERVER_ADDRESS;

Object
    .keys(ips)
    .forEach(function (_interface) {
        ips[_interface]
            .forEach(function (_dev) {
                if (_dev.family === 'IPv4' && !_dev.internal) ip = _dev.address
            })
    });

const app = express();
const server = createServer(app);

const corsOptions = {
    origin: '*',
    optionsSuccessStatus: 200,
};

app.use(cors(corsOptions));
app.use(express.static('static'))

app.get('/', (req, res) => {
    res.sendFile(join(__dirname, 'html', 'index.html'));
});

const io = new Server(server, {
    cors: {
        origin: '*',
        methods: ['GET'],
        credentials: false,
    },
});

// Which users are controlling and showing the slides.
const activeSockets = {
    master: null,
    follower: null,
};

// Which socket ids are associated to which roles.
const roles = new Map();

const handleDisconnect = (socket) => {
    const role = roles.get(socket.id);

    if (!role) {
        console.log('Guest user disconnected.');
        return;
    }

    if (activeSockets[role] && activeSockets[role].id === socket.id) {
        activeSockets[role] = null;
        roles.delete(socket.id);
        console.log(`User "${role}" disconnected:`);
    }
};

const handleConnect = (socket, role) => {
    const prevActiveSocket = activeSockets[role];

    if (prevActiveSocket) {
        activeSockets[role] = null;
        roles.delete(prevActiveSocket.id);
    }

    activeSockets[role] = socket;
    roles.set(socket.id, role);
    console.log(`User became "${role}".`);
};

const validateStatus = () => {
    if (activeSockets.follower && activeSockets.master)
        console.info('Can begin remote control.')
    else console.warn('Remote control not ready.')
}

// Socket.io connection event
io.on('connection', (socket) => {
    console.log(`Guest ${socket.id} connected.`)

    socket.on('register', (message) => {
        handleConnect(socket, message.role);
        validateStatus();
    });

    socket.on('action', (message) => {
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

server.listen(SERVER_PORT, SERVER_ADDRESS, 511, () => {
    console.log(`Controller server listening on http://${ip}:${SERVER_PORT}.`);
});
