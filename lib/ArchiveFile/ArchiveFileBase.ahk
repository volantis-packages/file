class ArchiveFileBase {
    archiveFile := ""
    _extra := Map()

    __New(archiveFile, extra := "") {
        InvalidParameterException.CheckTypes("ArchiveFileBase", "archiveFile", archiveFile, "")
        InvalidParameterException.CheckEmpty("ArchiveFileBase", "archiveFile", archiveFile)
        this.archiveFile := archiveFile

        if (extra) {
            if (List.IsMapLike(extra)) {
                for key, value in extra {
                    this._extra[key] := value
                }
            } else {
                this._extra := extra
            }
        }
    }

    /**
    * ABSTRACT METHODS
    */

    Extract(destinationPath) {
        throw(MethodNotImplementedException("ArchiveFileBase", "Extract"))
    }

    Compress(files, dir := "") {
        throw(MethodNotImplementedException("ArchiveFileBase", "Compress"))
    }
}
