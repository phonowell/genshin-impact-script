"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const fire_keeper_1 = __importDefault(require("fire-keeper"));
const lodash_1 = __importDefault(require("lodash"));
async function ask_(source, target) {
    const isExisted = [
        await fire_keeper_1.default.isExisted_(source),
        await fire_keeper_1.default.isExisted_(target),
    ];
    const mtime = [0, 0];
    if (isExisted[0]) {
        const stat = await fire_keeper_1.default.stat_(source);
        mtime[0] = stat
            ? stat.mtimeMs
            : 0;
    }
    if (isExisted[1]) {
        const stat = await fire_keeper_1.default.stat_(target);
        mtime[1] = stat
            ? stat.mtimeMs
            : 0;
    }
    const choice = [];
    if (isExisted[0])
        choice.push({
            title: [
                'overwrite, export',
                mtime[0] > mtime[1] ? '(newer)' : '',
            ].join(' '),
            value: 'export',
        });
    if (isExisted[1])
        choice.push({
            title: [
                'overwrite, import',
                mtime[1] > mtime[0] ? '(newer)' : '',
            ].join(' '),
            value: 'import',
        });
    if (!choice.length) {
        fire_keeper_1.default.info('skip');
        return 'skip';
    }
    let indexDefault = -1;
    for (let i = 0; i < choice.length; i++) {
        if (!choice[i].title.includes('(newer)'))
            continue;
        indexDefault = i;
        break;
    }
    choice.push({
        title: 'skip',
        value: 'skip',
    });
    return fire_keeper_1.default.prompt_({
        default: indexDefault,
        list: choice,
        message: 'and you decide to...',
        type: 'select',
    });
}
async function load_() {
    fire_keeper_1.default.info().pause();
    const listData = await Promise.all((await fire_keeper_1.default.source_('./data/sync/**/*.yaml'))
        .map(source => fire_keeper_1.default.read_(source)));
    fire_keeper_1.default.info().resume();
    let result = [];
    for (const data of listData)
        result = [
            ...result,
            ...data,
        ];
    return lodash_1.default.uniq(result);
}
async function main_() {
    const data = await load_();
    for (const line of data) {
        const _list = line.split('@');
        const [path, extra] = [_list[0], _list[1] || ''];
        const _list2 = extra.split('/');
        const [namespace, version] = [
            _list2[0] || 'default',
            _list2[1] || 'latest',
        ];
        const source = `./${path}`;
        let target = `../midway/${path}`;
        const { basename, dirname, extname } = fire_keeper_1.default.getName(target);
        target = `${dirname}/${basename}-${namespace}-${version}${extname}`;
        if (await fire_keeper_1.default.isSame_([source, target]))
            continue;
        fire_keeper_1.default.info(`'${source}' is different from '${target}'`);
        const value = await ask_(source, target);
        if (!value)
            break;
        await overwrite_(value, source, target);
    }
}
async function overwrite_(value, source, target) {
    if (value === 'export') {
        const { dirname, filename } = fire_keeper_1.default.getName(target);
        await fire_keeper_1.default.copy_(source, dirname, filename);
    }
    if (value === 'import') {
        const { dirname, filename } = fire_keeper_1.default.getName(source);
        await fire_keeper_1.default.copy_(target, dirname, filename);
    }
}
exports.default = main_;
