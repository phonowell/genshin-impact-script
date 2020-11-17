# Toolkit

## type

```typescript
type Point = [number, number]
```

## array

### reverse(input: unknown[]): unknown[]

## basic

### includes(input: string | array, needle: string): boolean

### length(input: string | array | object): number

### type(input: unknown): 'array' | 'number' | 'object' | 'string'

## finder

### findColor(color: number, start: Point = [0, 0], end: Point = [A_ScreenWidth, A_ScreenHeight], variation: number): Point

### findImage(source: string, start: Point = [0, 0], end: Point = [A_ScreenWidth, A_ScreenHeight]): Point

## getter

### getColor(point?: Point): number

### getPosition(): Point

### getState(key: string): string

## other

### formatHotkey(key: string): string

### now(): number

### random(min: number = 0, max: number = 1): number

## setter

### click(key?: string): void

### move(point: Point, speed: number = 0): void

### setFixed(fixed?: boolean): void

## speaker

### beep(): void

### i(message: string): string

### info(message: string, point?: Point): string

## string

### replace(input: string, searchment: string, replacement: string, limit: number = -1): string

### split(input: string, delimiter: string): string

### toLowerCase(input: string): string

### toString(input: unknown): string

### toUpperCase(input: string): string

### trim(input: string, omitting: string): string

### trimEnd(input: string, omitting: string): string

### trimStart(input: string, omitting: string): string

## system

### exit(): void

### off(key: string, fn: Function): void

### on(key, string, fn: Function): void

### open(source: string): void

### reload(): void

### sleep(time: number): void

### suspend(suspended?: boolean): void

## math

### abs(n: number): number

### ceil(n: number): number

### floor(n: number): number

### round(n: number): number

## other

### alert(message: string): string

## timer

### clearInterval(fn: Function): void

### clearTimeout(fn: Function): void

### setInterval(fn: Function, time: number): Function

### setTimeout(fn: Function, time: number): Function
