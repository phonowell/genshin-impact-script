"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const coffee_ahk_1 = __importDefault(require("coffee-ahk"));
async function main_() {
    await coffee_ahk_1.default('./source/index.coffee', {
        salt: 'genshin',
    });
}
exports.default = main_;
