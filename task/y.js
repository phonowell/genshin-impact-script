"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fire_keeper_1 = __importDefault(require("fire-keeper"));
async function main_() {
    await fire_keeper_1.default.compile_('./task/*.ts');
    await fire_keeper_1.default.remove_('./task/*.d.ts');
}
exports.default = main_;
