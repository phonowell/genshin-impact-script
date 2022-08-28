import $ from 'fire-keeper'

// function

const main = async () => {
  const pkg = await $.read<{
    dependencies: Record<string, string>
    devDependencies: Record<string, string>
  }>('./package.json')
  const listCmd = [
    ...Object.keys(pkg.devDependencies),
    ...Object.keys(pkg.dependencies),
  ].map((name) => `pnpm i ${name}@latest`)
  await $.exec(listCmd)
}

// export
export default main
