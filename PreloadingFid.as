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
#if TURBO
	PreloadingFid(CSystemFid@ fid) { @Fid = cast<CSystemFidFile>(fid); }
#endif

	void RenderDebug()
	{
		if (Setting_ShowDebugButtons) {
			if (UI::Button(Icons::Cube)) {
				ExploreNod(Nod);
			}
			UI::SameLine();
			if (UI::Button(Icons::FileO)) {
				ExploreNod(Fid);
			}
			UI::SameLine();
		}
	}

	bool opEquals(const PreloadingFid &in other) { return Fid is other.Fid; }
}
