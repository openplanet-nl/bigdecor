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
}
