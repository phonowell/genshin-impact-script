import $ from 'fire-keeper'

// function

const main = async () => {
  const listCharacter = await $.read<string[]>('./data/character/index.yaml')
  const listImport = listCharacter.map(name => `$.mixin data, ${name}: __${name}__`)
  console.log(listImport.join('\n'))
}

// export
export default main