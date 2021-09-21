import $ from 'fire-keeper'

// function

const main = async () => {
  await $.compile([
    './task/*.ts',
    '!./task/*.d.ts',
  ])
}

// export
export default main