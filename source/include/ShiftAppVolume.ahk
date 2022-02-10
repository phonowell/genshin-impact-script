ShiftAppVolumeTopped( appName, incr )
{
    if !appName
    {
        WinGet, activePID, ID, A
        WinGet, activeName, ProcessName, ahk_id %activePID%
        appName := activeName
    }

    IMMDeviceEnumerator := ComObjCreate( "{BCDE0395-E52F-467C-8E3D-C4579291692E}", "{A95664D2-9614-4F35-A746-DE8DB63617E6}" )
    DllCall( NumGet( NumGet( IMMDeviceEnumerator+0 ) + 4*A_PtrSize ), "UPtr", IMMDeviceEnumerator, "UInt", 0, "UInt", 1, "UPtrP", IMMDevice, "UInt" )
    ObjRelease(IMMDeviceEnumerator)

    VarSetCapacity( GUID, 16 )
    DllCall( "Ole32.dll\CLSIDFromString", "Str", "{77AA99A0-1BD6-484F-8BC7-2C654C9A9B6F}", "UPtr", &GUID)
    DllCall( NumGet( NumGet( IMMDevice+0 ) + 3*A_PtrSize ), "UPtr", IMMDevice, "UPtr", &GUID, "UInt", 23, "UPtr", 0, "UPtrP", IAudioSessionManager2, "UInt" )
    ObjRelease( IMMDevice )

    DllCall( NumGet( NumGet( IAudioSessionManager2+0 ) + 5*A_PtrSize ), "UPtr", IAudioSessionManager2, "UPtrP", IAudioSessionEnumerator, "UInt" )
    ObjRelease( IAudioSessionManager2 )

    DllCall( NumGet( NumGet( IAudioSessionEnumerator+0 ) + 3*A_PtrSize ), "UPtr", IAudioSessionEnumerator, "UIntP", SessionCount, "UInt" )
    Loop % SessionCount
    {
        DllCall( NumGet( NumGet( IAudioSessionEnumerator+0 ) + 4*A_PtrSize ), "UPtr", IAudioSessionEnumerator, "Int", A_Index-1, "UPtrP", IAudioSessionControl, "UInt" )
        IAudioSessionControl2 := ComObjQuery( IAudioSessionControl, "{BFB7FF88-7239-4FC9-8FA2-07C950BE9C6D}" )
        ObjRelease( IAudioSessionControl )

        DllCall( NumGet( NumGet( IAudioSessionControl2+0 ) + 14*A_PtrSize ), "UPtr", IAudioSessionControl2, "UIntP", PID, "UInt" )

        PHandle := DllCall( "OpenProcess", "uint", 0x0010|0x0400, "Int", false, "UInt", PID )
        if !( ErrorLevel or PHandle = 0 )
        {
            name_size = 1023
            VarSetCapacity( PName, name_size )
            DllCall( "psapi.dll\GetModuleFileNameEx" . ( A_IsUnicode ? "W" : "A" ), "UInt", PHandle, "UInt", 0, "Str", PName, "UInt", name_size )
            DllCall( "CloseHandle", PHandle )
            SplitPath PName, PName
            if ( PName = appName )
            {
                ISimpleAudioVolume := ComObjQuery(IAudioSessionControl2, "{87CE5498-68D6-44E5-9215-6DA47EF883D8}")
                DllCall( NumGet( NumGet( ISimpleAudioVolume+0 ) + 6*A_PtrSize ), "UPtr", ISimpleAudioVolume, "IntP", muted )  ; Get mute status
                if incr
                {
                    DllCall( NumGet( NumGet( ISimpleAudioVolume+0 ) + 4*A_PtrSize ), "UPtr", ISimpleAudioVolume, "FloatP", level, "UInt" )  ; Get volume
                    DllCall( NumGet( NumGet( ISimpleAudioVolume+0 ) + 3*A_PtrSize ), "UPtr", ISimpleAudioVolume, "Float", max( 0.0, min( 1.0, level + incr ) ) , "UPtr", 0, "UInt" )  ; Set volume
                    if muted
                        DllCall( NumGet( NumGet( ISimpleAudioVolume+0 ) + 5*A_PtrSize ), "UPtr", ISimpleAudioVolume, "Int", !muted , "UPtr", 0, "UInt" )  ; Unmute
                }
                else
                {
                    DllCall( NumGet( NumGet( ISimpleAudioVolume+0 ) + 5*A_PtrSize ), "UPtr", ISimpleAudioVolume, "Int", !muted , "UPtr", 0, "UInt" )  ; Set volume
                }
                ObjRelease(ISimpleAudioVolume)
            }
        }
        ObjRelease(IAudioSessionControl2)
    }
    ObjRelease(IAudioSessionEnumerator)
}