import { KeyBindingShell } from 'node_modules/shell-ahk/dist/type/keyBindingShell'
import * as SA from 'node_modules/shell-ahk/dist/type/module'

export type Shell = {
  Math: SA.Math
  alert: SA.Alert
  beep: SA.Beep
  clearInterval: SA.ClearInterval
  clearTimeout: SA.ClearTimeout
  click: SA.Click
  clone: SA.Clone
  confirm: SA.Confirm
  debounce: SA.Debounce
  delete: SA.Delete
  emitter: SA.Emitter
  eq: SA.Eq
  exit: SA.Exit
  file: SA.File
  filter: SA.Filter
  forEach: SA.ForEach
  getPosition: SA.GetPosition
  getType: SA.GetType
  httpGet: SA.HttpGet
  includes: SA.Includes
  isArray: SA.IsArray
  isFunction: SA.IsFunction
  isKeyBound: SA.IsKeyBound
  isKeyPreventedDefault: SA.IsKeyPreventedDefault
  isNumber: SA.IsNumber
  isPressing: SA.IsPressing
  isString: SA.IsString
  join: SA.Join
  keys: SA.Keys
  length: SA.Length
  map: SA.Map
  mixin: SA.Mixin
  move: SA.Move
  noop: SA.Noop
  now: SA.Now
  off: KeyBindingShell['remove']
  on: KeyBindingShell['add']
  open: SA.Open
  press: SA.Press
  preventDefaultKey: SA.PreventDefaultKey
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
