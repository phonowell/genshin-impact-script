import $ from 'fire-keeper'

// function

const main = async () => {
  await $.compile('./task/*.ts')
}

// export
export default main