import _openjlabel from '../wasm/openjlabel'

export interface OpenjlabelInstance {
  callMain: (args: string[]) => void
  FS: {
    mkdir: (path: string) => void
    writeFile: (path: string, data: Uint8Array) => void
    readFile: (path: string, options: { encoding: 'utf8' }) => string
  }
}

const openjlabel = _openjlabel as () => Promise<OpenjlabelInstance>

export { openjlabel as default }
