import $ from 'fire-keeper'

// function

const main = async () => {
  type Pkg = {
    dependencies?: Record<string, string>
    devDependencies?: Record<string, string>
  }

  const pkg = await $.read<Pkg>('./package.json')
  if (!pkg) throw new Error('package.json not found')

  const listCmd = [
    ...Object.keys(pkg?.devDependencies || []),
    ...Object.keys(pkg?.dependencies || []),
  ].map((name) => `pnpm i ${name}@latest`)

  await $.exec(listCmd)
}

// export
export default main
