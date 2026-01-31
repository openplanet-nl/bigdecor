class PreloadingFid
{
	CSystemFidFile@ Fid;

	CMwNod@ get_Nod()
	{
		if (Fid.Nod is null) {
			return Fids::Preload(Fid);
		}
		return Fid.Nod;
	}

	PreloadingFid(CSystemFidFile@ fid) { @Fid = fid; }

	bool opEquals(const PreloadingFid &in other) { return Fid is other.Fid; }
}
