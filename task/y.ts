import $ from 'fire-keeper'

// function

async function main_(): Promise<void> {

  await $.compile_('./task/*.ts')
  await $.remove_('./task/*.d.ts')
}

// export
export default main_