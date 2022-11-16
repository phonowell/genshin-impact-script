import { Name } from "./scene"

export class Scene2G {
  private aboutHalfMenu(): Name[]
  private aboutMenu(): Name[]
  private aboutNormal(): Name[]
  private check(): Name[]
  private checkIsAiming(): boolean
  private checkIsBusy(): boolean
  private checkIsChat(): boolean
  private checkIsDomain(): boolean
  private checkIsEvent(): boolean
  private checkIsHalfMenu(): boolean
  private checkIsLoading(): boolean
  private checkIsMap(): boolean
  private checkIsMenu(): boolean
  private checkIsMiniMenu(): boolean
  private checkIsMulti(): boolean
  private checkIsNormal(): boolean
  private checkIsParty(): boolean
  private checkIsPlaying(): boolean
  private makeListName(...names: Name[]): Name[]
  private throttle(name: Name, time: number, callback: () => boolean): boolean
}