import openjlabel from 'openjlabel'
import { readFileSync } from 'fs'
import { join } from 'path'

const dictDirPath = 'path/to/dictDir'
const memoryFSDictDirPath = '/dict'

const dictFileNames = [
  'char.bin',
  'left-id.def',
  'matrix.bin',
  'pos-id.def',
  'rewrite.def',
  'right-id.def',
  'sys.dic',
  'unk.dic'
]

const dictFiles = dictFileNames.map((dictFileName) => {
  const buffer = readFileSync(join(dictDirPath, dictFileName))
  return {
    path: join(memoryFSDictDirPath, dictFileName),
    data: new Uint8Array(buffer)
  }
})

openjlabel()
.then((instance) => {
  const memoryFS = instance.FS

  memoryFS.mkdir(memoryFSDictDirPath)
  dictFiles.forEach((dictFile) => memoryFS.writeFile(dictFile.path, dictFile.data))

  const labelFilePath = '/output.lab'
  const text = 'こんにちは'
  const args = [
    '-d', memoryFSDictDirPath,
    '-o', labelFilePath,
    text
  ]

  instance.callMain(args)

  const label = memoryFS.readFile(labelFilePath, { encoding: 'utf8' })
  console.log(label)
})
.catch(console.error)
