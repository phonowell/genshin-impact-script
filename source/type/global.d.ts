import { AliceG } from './alice'
import { AreaG } from './area'
import { BuffG } from './buff'
import { CameraG } from './camera'
import { CharacterG } from './character'
import { ClientG } from './client'
import { ColorManagerG } from './color-manager'
import { ConfigG } from './config'
import { ControllerG } from './controller'
import { CursorG } from './cursor'
import { DashboardG } from './dashboard'
import { DictionaryG } from './dictionary'
import { EmitterShell as ES } from 'node_modules/shell-ahk/dist/type/emitterShell'
import { FishingG } from './fishing'
import { GdipG } from './gdip'
import { HudG } from './hud'
import { IdleG } from './idle'
import { IndicatorG } from './indicator'
import { JumperG } from './jumper'
import { KeyBinding as KB } from './key-binding'
import { MenuG } from './menu'
import { MovementG } from './movement'
import { Party2G } from './party2'
import { PartyG } from './party'
import { PickerG } from './picker'
import { PointG } from './point'
import { RecorderG } from './recorder'
import { ReplayerG } from './replayer'
import { Scene2G } from './scene2'
import { SceneG } from './scene'
import { Shell } from './shell'
import { SkillG } from './skill'
import { SoundG } from './sound'
import { Status2G } from './status'
import { TacticG } from './tactic'
import { TimerG } from './timer'
import { TransparentG } from './transparent'
import { UpgraderG } from './upgrader'
import { WindowG } from './window'

declare global {
  class Console {
    init(): void
  }

  class EmitterShell {
    constructor()
    on: ES['on']
    once: ES['once']
    off: ES['off']
    emit: ES['emit']
  }

  class KeyBinding extends EmitterShell {
    isFired: KB['isFired']
    isPressed: KB['isPressed']
    map: KB['map']

    registerEvent: KB['registerEvent']
    unregisterEvent: KB['unregisterEvent']
  }

  const $: Shell
  const A_ScreenHeight: number
  const A_ScreenWidth: number
  const A_language: string
  const Format: (f: string, v: string | number) => string
  const Gdip_BitmapFromScreen: (area: string) => number
  const Gdip_DisposeImage: (bitmap: number) => void
  const Gdip_GetPixel: (bitmap: number, x: number, y: number) => number
  const Gdip_Shutdown: (token: number) => void
  const Gdip_Startup: () => number
  const GetKeyState: (key: string, type: string) => boolean
  const Native: (...args: unknown[]) => unknown
  const OnExit: (fn: Fn) => void
  const Round: (a: number, b: number) => number
  const ShiftAppVolumeTopped: (app: string, volume: number) => void
  const XInput_Init: () => void

  const Gdip_CloneBitmapArea: (
    bitmap: number,
    x: number,
    y: number,
    width: number,
    height: number
  ) => number

  const Gdip_PixelSearch: (
    area: number,
    color: number,
    x: number,
    y: number
  ) => number

  const XInput_GetState: (target: number) => {
    wButtons: number
    bLeftTrigger: number
    bRightTrigger: number
    sThumbLX: number
    sThumbLY: number
    sThumbRX: number
    sThumbRY: number
  }

  const Alice: AliceG
  const Area: AreaG
  const Buff: BuffG
  const Camera: CameraG
  const Character: CharacterG
  const Client: ClientG
  const ColorManager: ColorManagerG
  const Config: ConfigG
  const Controller: ControllerG
  const Cursor: CursorG
  const Dashboard: DashboardG
  const Dictionary: DictionaryG
  const Fishing: FishingG
  const Gdip: GdipG
  const Hud: HudG
  const Idle: IdleG
  const Indicator: IndicatorG
  const Jumper: JumperG
  const Menu2: MenuG
  const Movement: MovementG
  const Party2: Party2G
  const Party: PartyG
  const Picker: PickerG
  const Point: PointG
  const Recorder: RecorderG
  const Replayer: ReplayerG
  const Scene2: Scene2G
  const Scene: SceneG
  const Skill: SkillG
  const Sound: SoundG
  const Status2: Status2G
  const Tactic: TacticG
  const Timer: TimerG
  const Transparent: TransparentG
  const Upgrader: UpgraderG
  const Window2: WindowG
  const alice: never
  const area: never
  const buff: never
  const camera: never
  const character: never
  const client: never
  const colorManager: never
  const config: never
  const controller: never
  const cursor: never
  const dashboard: never
  const dictionary: never
  const fishing: never
  const gdip: never
  const hud: never
  const idle: never
  const indicator: never
  const jumper: never
  const menu2: never
  const movement: never
  const party2: never
  const party: never
  const picker: never
  const point: never
  const recorder: never
  const replayer: never
  const scene2: never
  const scene: never
  const skill: never
  const sound: never
  const status2: never
  const tactic: never
  const timer: never
  const transparent: never
  const upgrader: never
  const window2: never
}

export type AreaLike = (number | string)[] | (number | string)[][]
export type Fn = (...args: unknown[]) => unknown
export type PointLike = (number | string)[]
