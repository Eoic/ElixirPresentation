#!/bin/bash
pm2 delete all
npm run --prefix ./slides start
