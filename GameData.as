namespace GameData
{
	string GetCollectionId(CGameCtnCollection@ collection)
	{
#if TMNEXT
		return collection.CollectionId_Text;
#elif MP4 || TURBO
		return collection.DisplayName; //todo: can we do this on Next too?
#else
		throw("GetCollectionId not implemented for this game!");
		return "unknown";
#endif
	}

	array<PreloadingFid@> Collections;
	array<string> PlayerModels;

	void Initialize()
	{
		Collections.RemoveRange(0, Collections.Length);
		PlayerModels.RemoveRange(0, PlayerModels.Length);

		auto title = cast<CTrackMania>(GetApp()).LoadedManiaTitle;
		if (title is null) {
			return;
		}

#if TMNEXT
		PlayerModels = {
			"CarSport",
			"CarSnow",
			"CarRally",
			"CarDesert",
			"CharacterPilot",
		};
#endif

		for (uint i = 0; i < title.CollectionFids.Length; i++) {
			auto fid = cast<CSystemFidFile>(title.CollectionFids[i]);
			if (fid.Nod is null) {
				Fids::Preload(fid);
			}
			auto collection = cast<CGameCtnCollection>(fid.Nod);
			if (collection !is null) {
				Collections.InsertLast(fid);
#if !TMNEXT
				PlayerModels.InsertLast(collection.VehicleName.GetName());
#endif
			}
		}
	}

	array<PreloadingFid@> Decorations;

	void LoadDecorationsForCollection(CGameCtnCollection@ collection)
	{
		Decorations.RemoveRange(0, Decorations.Length);

		if (collection.FolderDecoration is null) {
			error("Decoration folder for collection '" + GetCollectionId(collection) + "' is null");
			return;
		}

		auto folder = collection.FolderDecoration;
		for (uint i = 0; i < folder.Leaves.Length; i++) {
			auto fid = folder.Leaves[i];
			if (fid.Nod is null) {
				Fids::Preload(fid);
			}
			auto deco = cast<CGameCtnDecoration>(fid.Nod);
			if (deco !is null && !deco.IsInternal) {
				Decorations.InsertLast(fid);
			}
		}
	}

	array<string> TextureMods;

	void LoadTextureModsForCollection(CGameCtnCollection@ collection)
	{
		TextureMods.RemoveRange(0, TextureMods.Length);

		string path = "Skins/" + GetCollectionId(collection) + "/Mod";

		LoadTextureModsInFolder(Fids::GetUserFolder(path));

		auto folderTitles = Fids::GetFakeFolder("Titles");
		if (folderTitles !is null) {
			for (uint j = 0; j < folderTitles.Trees.Length; j++) {
				LoadTextureModsInFolder(Fids::GetFidsFolder(folderTitles.Trees[j], path));
			}
		}
	}

	void LoadTextureModsInFolder(CSystemFidsFolder@ folder)
	{
		if (folder is null) {
			return;
		}
		Fids::UpdateTree(folder);
		for (uint i = 0; i < folder.Leaves.Length; i++) {
			auto fidMod = cast<CSystemFidFile>(folder.Leaves[i]);
			TextureMods.InsertLast(fidMod.FileName);
		}
	}
}
