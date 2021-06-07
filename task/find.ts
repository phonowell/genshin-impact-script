import $source_ from 'fire-keeper/source_'
import $write_ from 'fire-keeper/write_'
import { createCanvas, loadImage, NodeCanvasRenderingContext2D } from 'canvas'

// function

const formatColor = (
  input: string
): string => input.split(',').map(item => Number(item).toString(16).padStart(2, '0')).join('').toUpperCase()

const getList = async (
  ctx: NodeCanvasRenderingContext2D,
  path: string,
): Promise<Set<string>> => {

  const [source] = await $source_(path)
  const img = await loadImage(source)
  const { width, height } = img
  ctx.drawImage(img, 0, 0, width, height)
  const list = ctx.getImageData(0, 0, width, height).data

  const result = new Set<string>()

  for (let i = 0; i < list.length / 4; i++) {
    const n = i * 4
    result.add(`${list[n]},${list[n + 1]},${list[n + 2]}`)
  }

  return result
}

const main = async () => {
  const canvas = createCanvas(100, 100)
  const ctx = canvas.getContext('2d')

  const setA = await getList(ctx, 'F:/0.png')
  const setB = await getList(ctx, 'F:/1.png')

  const setC = new Set<string>([...setA].filter(item => setB.has(item)))

  await $write_('./data/color.yaml', [...setC].map(formatColor).map(item => `- #${item}, 0x${item}`).join('\n'))
}

// export
export default main