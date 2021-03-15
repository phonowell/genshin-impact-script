import $ from 'fire-keeper'

// function

const main = async (): Promise<void> => {

  const version = await savePkg()
  if (!version) return

  await saveMd(version)
}

const saveMd = async (
  version: string,
): Promise<void> => {

  const listSource = [
    './readme.md',
    './readme-cn.md',
  ]

  for (const source of listSource) {
    // eslint-disable-next-line no-await-in-loop
    const content = await $.read_(source) as string
    const cont = content
      .replace(/\d+\.\d+\.\d+/g, version)
    // eslint-disable-next-line no-await-in-loop
    await $.write_(source, cont)
  }
}

const savePkg = async (): Promise<string> => {

  type Pkg = {
    version: string
  }

  const pkg = await $.read_('./package.json') as Pkg

  const version = await $.prompt_({
    default: pkg.version,
    message: 'input version',
    type: 'text',
  })

  if (version.split('.').length !== 3) return ''
  pkg.version = version

  await $.write_('./package.json', pkg)
  return version
}

// export
export default main