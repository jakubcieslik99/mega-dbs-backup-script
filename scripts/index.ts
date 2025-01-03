import * as dotenv from 'dotenv'
import * as fs from 'fs'
import { ReadStream } from 'fs'
import { Storage } from 'megajs'

dotenv.config({ path: './.env' })
const BACKUPS_DIR = `./backups_${process.env.DB}`.trim()

const getEntries = () => {
  const entries = fs.readdirSync(BACKUPS_DIR)
  if (entries.length === 0) throw new Error('No entries found in MongoDB backups.')

  const retentionHours = process.env.RETENTION_HOURS ? parseInt(process.env.RETENTION_HOURS) : null
  if (!retentionHours || isNaN(retentionHours)) throw new Error('Invalid retention hours value.')

  const entriesToDelete = listEntriesToDelete(entries, retentionHours)

  const newestEntry = entries.reduce((acc, currentEntry) => {
    return currentEntry > acc ? currentEntry : acc
  }, entries[0])

  return { newestEntry, entriesToDelete }
}

const listEntriesToDelete = (entries: string[], retentionHours: number) => {
  const retentionDate = new Date(Date.now() - retentionHours * 60 * 60 * 1000)

  return entries.filter(entry => {
    const entryDate = fs.statSync(`${BACKUPS_DIR}/${entry}`).ctime
    return entryDate < retentionDate
  })
}

const prepareStorage = async () => {
  const storage = new Storage({
    email: process.env.MEGA_EMAIL || '',
    password: process.env.MEGA_PASSWORD || '',
    userAgent: process.env.MEGA_USER_AGENT || '',
  })
  await storage.ready

  const storageDirectory = await prepareStorageDirectory(storage)
  storage.root = storageDirectory

  return storage
}

const prepareStorageDirectory = async (storage: Storage) => {
  const directoryName = process.env.PROJECT_NAME || 'mega-dbs-backup-script'

  const directory = storage.root.children?.find(path => path.name === directoryName)
  if (directory) return directory

  return await storage.mkdir(directoryName)
}

const uploadNewestEntry = async (storage: Storage, newestEntry: string) => {
  const filePath = `${BACKUPS_DIR}/${newestEntry}`.trim()
  const fileSize = (await fs.promises.stat(filePath)).size

  const fileStream: ReadStream = fs.createReadStream(filePath)
  const fileBuffer: Buffer = await new Promise((resolve, reject) => {
    const chunks: Buffer[] = []
    fileStream.on('data', (chunk: Buffer) => chunks.push(chunk))
    fileStream.on('end', () => resolve(Buffer.concat(chunks)))
    fileStream.on('error', reject)
  })

  const newFile = await storage.upload({ name: newestEntry, size: fileSize }, fileBuffer).complete
  const newFileLink = await newFile.link(false)
  console.log(`[LOG]: Successfully uploaded file: ${newestEntry} to MEGA Drive: ${newFileLink}.`)
}

const deleteFiles = async (storage: Storage, entriesToDelete: string[]) => {
  const uploadedFiles = Object.values(storage.files)
  if (uploadedFiles.length === 0 || entriesToDelete.length === 0) return

  const filesToDelete = uploadedFiles.filter(file => entriesToDelete.includes(file.name as string))

  await Promise.all(filesToDelete.map(file => file.delete(true)))
  console.log('[LOG]: Successfully deleted files beyond the retention time from MEGA Drive.')
}

;(async () => {
  const { newestEntry, entriesToDelete } = getEntries()

  const storage = await prepareStorage()

  await uploadNewestEntry(storage, newestEntry)
  await deleteFiles(storage, entriesToDelete)

  await storage.close()
  process.exit(0)
})().catch(error => {
  if (error instanceof Error) console.error(`[ERR]: ${error.message}`)
  else console.error(`[ERR]: ${error}`)
  process.exit(1)
})
