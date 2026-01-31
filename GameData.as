namespace GameData
{
	array<PreloadingFid@> Collections;

	void LoadCollections()
	{
		Collections.RemoveRange(0, Collections.Length);

		auto title = cast<CTrackMania>(GetApp()).LoadedManiaTitle;
		for (uint i = 0; i < title.CollectionFids.Length; i++) {
			auto fid = cast<CSystemFidFile>(title.CollectionFids[i]);
			if (fid.Nod is null) {
				Fids::Preload(fid);
			}
			if (cast<CGameCtnCollection>(fid.Nod) !is null) {
				Collections.InsertLast(fid);
			}
		}
	}

	array<string> PlayerModels = {
		"CarSport",
		"CarSnow",
		"CarRally",
		"CarDesert",
		"CharacterPilot",
	};

	array<PreloadingFid@> Decorations;

	void LoadDecorationsForCollection(CGameCtnCollection@ collection)
	{
		Decorations.RemoveRange(0, Decorations.Length);

		if (collection.FolderDecoration is null) {
			error("Decoration folder for collection '" + collection.CollectionId_Text + "' is null");
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

		string path = "Skins/" + collection.CollectionId_Text + "/Mod";

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
			auto fidMod = folder.Leaves[i];
			TextureMods.InsertLast(fidMod.FileName);
		}
	}
}
