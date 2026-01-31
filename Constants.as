//TODO: rename to GameData or something?

namespace Constants
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

	CGameCtnCollection@ FindCollection(const string &in id)
	{
		for (uint i = 0; i < Collections.Length; i++) {
			auto collectionFid = Collections[i];
			auto collection = cast<CGameCtnCollection>(collectionFid.Nod);
			if (collection.CollectionId_Text == id) {
				return collection;
			}
		}
		return null;
	}

	array<string> PlayerModels = {
		"CarSport",
		"CarSnow",
		"CarRally",
		"CarDesert",
		"CharacterPilot",
	};

	array<PreloadingFid@> Decorations;

	void LoadDecorationsForCollection(const string &in id)
	{
		Decorations.RemoveRange(0, Decorations.Length);

		auto collection = FindCollection(id);
		if (collection is null) {
			error("Collection with id '" + id + "' could not be found");
			return;
		}

		if (collection.FolderDecoration is null) {
			error("Decoration folder for collection with id '" + id + "' is null");
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

	void LoadTextureModsForEnvironment(const string &in environment)
	{
		TextureMods.RemoveRange(0, TextureMods.Length);

		string path = "Skins/" + environment + "/Mod";
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
