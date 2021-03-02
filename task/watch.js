"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const coffee_ahk_1 = __importDefault(require("coffee-ahk"));
const watch_1 = __importDefault(require("fire-keeper/watch"));
class Compiler {
    constructor() {
        this.isBusy = false;
        this.list = [];
        setInterval(() => {
            this.next();
        }, 1e3);
    }
    add(path) {
        if (!this.list.includes(path))
            this.list.push(path);
    }
    next() {
        if (!this.list?.length)
            return;
        if (this.isBusy)
            return;
        this.isBusy = true;
        coffee_ahk_1.default(this.list.shift(), {
            salt: 'genshin',
        })
            .catch(e => {
            console.log(e.stack);
        })
            .finally(() => {
            this.isBusy = false;
        });
    }
}
function main() {
    process.on('uncaughtException', e => console.error(e));
    const compiler = new Compiler();
    watch_1.default('./source/**/*.coffee', () => {
        compiler.add('./source/index.coffee');
    });
}
exports.default = main;
