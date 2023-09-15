class ZipArchive7z extends ArchiveFileBase {
    __New(archiveFile, extra := "") {
        if (!extra) {
            extra := Map()
        }

        if (Type(extra) == "String") {
            extra := Map("exePath", extra)
        }

        if (!List.IsMapLike(extra)) {
            throw DataException("extra parameter must be a map")
        }

        if (!extra.Has("exePath")) {
            scriptDir := (extra.Has("scriptDir") && extra["scriptDir"]) ?
                extra["scriptDir"] :
                A_ScriptDir

            extra["exePath"] := scriptDir . "\vendor\ext\7zip\" . (A_Is64bitOS ? "64bit" : "32bit") . "\7za.exe"
        }

        super.__New(archiveFile, extra)
    }

    Extract(destinationPath) {
        RunWait(this.extra["exePath"] . " x `"" . this.archiveFile . "`" -o`"" . destinationPath . "\`" -y",, "Hide")
    }

    Compress(pattern, dir := "") {
        if (!dir) {
            dir := A_WorkingDir
        }

        RunWait(this.extra["exePath"] . " a `"" . this.archiveFile . "`" `"" . pattern . "`" -y", dir, "Hide")
    }
}
