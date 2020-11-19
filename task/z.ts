import compile_ from 'coffee-ahk'

// function

async function main_(): Promise<void> {

  await compile_('./source/z.coffee', {
    salt: 'z'
  })
}

// export
export default main_