import * as SA from 'node_modules/shell-ahk/dist/type/module'
import { KeyBindingShell } from 'node_modules/shell-ahk/dist/type/keyBindingShell'

export type Shell = {
  Math: SA.Math
  alert: SA.Alert
  beep: SA.Beep
  clearInterval: SA.ClearInterval
  clearTimeout: SA.ClearTimeout
  click: SA.Click
  confirm: SA.Confirm
  delete: SA.Delete
  emitter: SA.Emitter
  eq: SA.Eq
  exit: SA.Exit
  file: SA.File
  filter: SA.Filter
  forEach: SA.ForEach
  get: SA.Get
  getPosition: SA.GetPosition
  getState: SA.GetState
  getType: SA.GetType
  includes: SA.Includes
  isArray: SA.IsArray
  isFunction: SA.IsFunction
  isNumber: SA.IsNumber
  isString: SA.IsString
  join: SA.Join
  keys: SA.Keys
  length: SA.Length
  map: SA.Map
  max: SA.Max
  min: SA.Min
  mixin: SA.Mixin
  move: SA.Move
  noop: SA.Noop
  now: SA.Now
  off: KeyBindingShell['remove']
  on: KeyBindingShell['add']
  open: SA.Open
  press: SA.Press
  push: SA.Push
  reload: SA.Reload
  replace: SA.Replace
  setInterval: SA.SetInterval
  setTimeout: SA.SetTimeout
  slice: SA.Slice
  split: SA.Split
  startsWith: SA.StartsWith
  subString: SA.SubString
  sum: SA.Sum
  suspend: SA.Suspend
  tail<T>(list: T[]): T[]
  throttle: SA.Throttle
  toLowerCase: SA.ToLowerCase
  toNumber: SA.ToNumber
  toString: SA.ToString
  trigger: KeyBindingShell['fire']
  trim: SA.Trim
  unshift: SA.Unshift
  window: SA.Window
}
