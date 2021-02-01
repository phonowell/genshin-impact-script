import c2a from 'coffee-ahk'

// function

async function main_(): Promise<void> {

  await c2a('./source/index.coffee', {
    salt: 'genshin',
  })
}

// export
export default main_