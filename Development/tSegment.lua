--- @class NCSegment
--- @field Active boolean
--- @field FinishTime number
--- @field Identifier string|nil
--- @field StartTime number
--- @field Success boolean
--- @field TotalTime number
--- @field Wipe boolean
--- @field ActionPoints table<string, number>
--- @field Affixes table<string, number>
--- @field AvoidableDamage table<string, number>
--- @field CrowdControl table<string, number>
--- @field Deaths table<string, number>
--- @field Defensives table<string, number>
--- @field Dispells table<string, number>
--- @field Heals table<string, number>
--- @field Interrupts table<string, number>
--- @field Kills table<string, number>
--- @field OffHeals table<string, number>
--- @field Pulls table<string, number>
--- @field Rankings table
--- @field Segments table<NCSegment>
--- @field ActiveSegments table<NCSegment>
--- @field RosterSnapshot table<string, GroupRosterPlayer>
--- @field Observers table
--- @field DetailsSegment integer
--- @field StartPreHook fun(self: NCSegment)
--- @field Start fun(self: NCSegment)
--- @field StartCallback fun(self: NCSegment)
--- @field Finish fun(self: NCSegment, success: boolean)
--- @field SetActive fun(self: NCSegment)
--- @field SetActiveCallback fun(self: NCSegment)
--- @field SetInactive fun(self: NCSegment)
--- @field SetInactiveCallback fun(self: NCSegment)
--- @field IsActive fun(self: NCSegment): boolean
--- @field IsInactive fun(self: NCSegment): boolean
--- @field IsSuccess fun(self: NCSegment): boolean
--- @field IsWipe fun(self: NCSegment): boolean
--- @field GetFinishTime fun(self: NCSegment): number
--- @field GetStartTime fun(self: NCSegment): number
--- @field GetTotalTime fun(self: NCSegment): number
--- @field GetAffixes fun(self: NCSegment, player: string|nil): table<string, number>|number
--- @field AddActionPoints fun(self: NCSegment, amount: number, player: string, optDescription: string|nil)
--- @field AddActionPointsCallback fun(self: NCSegment, amount: number, player: string, optDescription: string|nil)
--- @field GetActionPoints fun(self: NCSegment, player: string|nil): table<string, table>|table
--- @field GetActionPointsAmount fun(self: NCSegment, player: string): number
--- @field AddAffix fun(self: NCSegment, player: string, optCount: number|nil)
--- @field AddAffixCallback fun(self: NCSegment, player: string)
--- @field GetAvoidableDamage fun(self: NCSegment, player: string|nil): table<string, number>|number
--- @field AddAvoidableDamage fun(self: NCSegment, amount: number, player: string)
--- @field AddAvoidableDamageCallback fun(self: NCSegment, amount: number, player: string)
--- @field GetCrowdControls fun(self: NCSegment, player: string|nil): table<string, number>|number
--- @field AddCrowdControl fun(self: NCSegment, player: string)
--- @field AddCrowdControlCallback fun(self: NCSegment, player: string)
--- @field GetDeaths fun(self: NCSegment, player: string|nil): table<string, number>|number
--- @field AddDeath fun(self: NCSegment, player: string)
--- @field AddDeathCallback fun(self: NCSegment, player: string)
--- @field GetDefensives fun(self: NCSegment, player: string|nil): table<string, number>|number
--- @field AddDefensive fun(self: NCSegment, player: string)
--- @field AddDefensiveCallback fun(self: NCSegment, player: string)
--- @field GetDispells fun(self: NCSegment, player: string|nil): table<string, number>|number
--- @field AddDispell fun(self: NCSegment, player: string)
--- @field AddDispellCallback fun(self: NCSegment, player: string)
--- @field GetHeals fun(self: NCSegment, player: string|nil): table<string, number>|number
--- @field AddHeals fun(self: NCSegment, amount: number, source: string, target: string)
--- @field AddHealsCallback fun(self: NCSegment, amount: number, player: string)
--- @field GetIdentifier fun(self: NCSegment): string
--- @field SetIdentifier fun(self: NCSegment, identifier: string)
--- @field GetInterrupts fun(self: NCSegment, player: string|nil): table<string, number>|number
--- @field AddInterrupt fun(self: NCSegment, player: string)
--- @field AddInterruptCallback fun(self: NCSegment, player: string)
--- @field GetKills fun(self: NCSegment, player: string|nil): table<string, number>|number
--- @field AddKill fun(self: NCSegment, player: string)
--- @field AddKillCallback fun(self: NCSegment, player: string)
--- @field GetOffHeals fun(self: NCSegment, player: string|nil): table<string, number>|number
--- @field AddOffHeals fun(self: NCSegment, amount: number, player: string)
--- @field AddOffHealsCallback fun(self: NCSegment, amount: number, player: string)
--- @field GetPulls fun(self: NCSegment, player: string|nil): table<string, number>|number
--- @field AddPull fun(self: NCSegment, player: string)
--- @field AddPullCallback fun(self: NCSegment, player: string)
--- @field GetStats fun(self: NCSegment, playerName: string|nil, metric: string): number
--- @field GetDps fun(self: NCSegment, playerName: string): number
--- @field GetDetailsSegment fun(self: NCSegment): integer
--- @field SetDetailsSegment fun(self: NCSegment, detailsSegment: integer)
--- @field GetLowestPerformer fun(self: NCSegment): string
--- @field GetHighestPerformer fun(self: NCSegment): string
--- @field GlobalAddActionPoints fun(self: NCSegment, amount: number, player: string, optDescription: string|nil)
--- @field GlobalAddAffix fun(self: NCSegment, player: string, optCount: number|nil)
--- @field GlobalAddAvoidableDamage fun(self: NCSegment, amount: number, player: string)
--- @field GlobalAddCrowdControl fun(self: NCSegment, player: string)
--- @field GlobalAddDeath fun(self: NCSegment, player: string)
--- @field GlobalAddDefensive fun(self: NCSegment, player: string)
--- @field GlobalAddDispell fun(self: NCSegment, player: string)
--- @field GlobalAddHeals fun(self: NCSegment, amount: number, source: string, target: string)
--- @field GlobalAddInterrupt fun(self: NCSegment, player: string)
--- @field GlobalAddKill fun(self: NCSegment, player: string)
--- @field GlobalAddPull fun(self: NCSegment, player: string)
--- @field GlobalReset fun(self: NCSegment)
--- @field SnapshotCurrentRoster fun(self: NCSegment)
--- @field New fun(self: NCSegment, identifier: string): NCSegment
--- @field Destroy fun(self: NCSegment)
--- @field Reset fun(self: NCSegment, optIdentifier: string|nil, optStart: boolean|nil)
--- @field ResetCallback fun(self: NCSegment, optIdentifier: string|nil, optStart: boolean|nil)
--- @field Restore fun(self: NCSegment, backup: NCSegmentBackup)
--- @field GetBackup fun(self: NCSegment): NCSegmentBackup
--- @field RegisterObserver fun(self: NCSegment, observer: table)
--- @field UnregisterObserver fun(self: NCSegment, observer: table)
--- @field NotifyObservers fun(self: NCSegment, statType: string, player: string, value: number)
