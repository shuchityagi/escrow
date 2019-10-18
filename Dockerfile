FROM mhart/alpine-node:12

COPY package.json ./

WORKDIR /
RUN npm install
COPY . .

RUN npm --global config set user root && \
    npm --global install truffle

CMD ["truffle", "build"]