"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fire_keeper_1 = __importDefault(require("fire-keeper"));
async function main_() {
    const source = './package.json';
    const pkg = await fire_keeper_1.default.read_(source);
    const listCmd = [];
    if (pkg.dependencies)
        Object.keys(pkg.dependencies)
            .forEach(key => {
            const value = pkg.dependencies[key];
            if (!value.startsWith('^'))
                return;
            listCmd.push(`npm i --legacy-peer-deps ${key}@latest`);
        });
    if (pkg.devDependencies)
        Object.keys(pkg.devDependencies)
            .forEach(key => {
            const value = pkg.devDependencies[key];
            if (!value.startsWith('^'))
                return;
            listCmd.push(`npm i -D --legacy-peer-deps ${key}@latest`);
        });
    if (pkg.peerDependencies)
        Object.keys(pkg.peerDependencies)
            .forEach(key => {
            const value = pkg.peerDependencies[key];
            if (!value.startsWith('^'))
                return;
            listCmd.push(`npm i ${key}@latest`);
        });
    await fire_keeper_1.default.exec_(listCmd);
}
exports.default = main_;
