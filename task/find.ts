import $source from 'fire-keeper/source'
import $write from 'fire-keeper/write'
import { createCanvas, loadImage, NodeCanvasRenderingContext2D } from 'canvas'
import _sortBy from 'lodash/sortBy'

// interface

type MapColor = {
  [x: string]: number
}

// variable

const listSource = [
  'F:/1.png',
  'F:/2.png',
  'F:/3.png',
  'F:/4.png',
]

// function

const formatColor = (
  input: string
): string => input.split(',').map(item => Number(item).toString(16).padStart(2, '0')).join('').toUpperCase()

const getMap = async (
  ctx: NodeCanvasRenderingContext2D,
  path: string,
): Promise<MapColor> => {

  const [source] = await $source(path)
  const img = await loadImage(source)
  const { width, height } = img
  ctx.drawImage(img, 0, 0, width, height)
  const list = ctx.getImageData(0, 0, width, height).data

  const result: MapColor = {}

  for (let i = 0; i < list.length / 4; i++) {
    const n = i * 4
    const color = `${list[n]},${list[n + 1]},${list[n + 2]}`
    result[color] = (result[color] || 0) + 1
  }

  return result
}

const main = async () => {
  const canvas = createCanvas(100, 100)
  const ctx = canvas.getContext('2d')

  let result: MapColor = {}

  for (const source of listSource) {
    const map = await getMap(ctx, source)
    if (source === listSource[0]) {
      result = map
      continue
    }
    const listKey = Object.keys(result)
    if (!listKey.length) break

    let res: MapColor = {}
    listKey.forEach(key => {
      if (map[key]) res[key] = result[key] + map[key]
    })

    result = res
  }

  const listResult = _sortBy(Object.keys(result).map(key => ({
    color: formatColor(key),
    count: result[key],
  })), 'count')
  listResult.reverse()

  if (!listResult.length) throw new Error('result is empty')

  await $write('./data/color.yaml', listResult.map(it => {
    return `- #${it.color} / 0x${it.color}  / ${it.count} times`
  }).join('\n'))
}

// export
export default main