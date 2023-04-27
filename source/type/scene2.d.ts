import { Fn } from './global'
import { Name } from './scene'

export class Scene2G {
  private cache: object
  private mapAbout: Record<Name, Fn>
  constructor()
  private aboutDialogue(): Name[]
  private aboutHalfMenu(): Name[]
  private aboutLoading(): Name[]
  private aboutMenu(): Name[]
  private aboutMiniMenu(): Name[]
  private aboutNormal(): Name[]
  check(): Name[]
  private checkIsChat(): boolean
  private checkIsDialogue(): boolean
  private checkIsDomain(): boolean
  private checkIsHalfMenu(): boolean
  private checkIsLoading(): boolean
  private checkIsMap(): boolean
  private checkIsMenu(): boolean
  private checkIsMiniMenu(): boolean
  private checkIsNormal(): boolean
  private checkIsParty(): boolean
  private checkIsPlaying(): boolean
  private makeListName(...names: Name[]): Name[]
  private throttle(id: string, interval: number, fn: () => boolean): boolean
}
