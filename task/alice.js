"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    Object.defineProperty(o, k2, { enumerable: true, get: function() { return m[k]; } });
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fire_keeper_1 = __importDefault(require("fire-keeper"));
async function ask_(list) {
    const answer = await fire_keeper_1.default.prompt_({
        id: 'default-task',
        list,
        message: 'select a task',
        type: 'auto',
    });
    if (!answer)
        return '';
    if (!list.includes(answer))
        return ask_(list);
    return answer;
}
async function load_() {
    const listSource = await fire_keeper_1.default.source_([
        './task/*.js',
        './task/*.ts',
        '!*.d.ts',
    ]);
    const listResult = [];
    for (const source of listSource) {
        const basename = fire_keeper_1.default.getBasename(source);
        if (basename === 'alice')
            continue;
        if (listResult.includes(basename))
            continue;
        listResult.push(basename);
    }
    return listResult;
}
async function main_() {
    let task = fire_keeper_1.default.argv()._[0]
        ? fire_keeper_1.default.argv()._[0].toString()
        : '';
    const list = await load_();
    if (!task) {
        task = await ask_(list);
        if (!task)
            return;
    }
    await run_(task);
}
async function run_(task) {
    const [source] = await fire_keeper_1.default.source_([
        `./task/${task}.js`,
        `./task/${task}.ts`,
    ]);
    const fn_ = (await Promise.resolve().then(() => __importStar(require(source)))).default;
    await fn_();
}
main_();
