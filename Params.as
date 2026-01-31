namespace Params
{
	PreloadingFid@ Collection;
	PreloadingFid@ Decoration;
	string PlayerModel;
	string TextureMod;
	nat3 DecoSize;

	void Initialize()
	{
		GameData::Initialize();
		if (GameData::Collections.Length == 0) {
			error("No environments found!");
			return;
		}

		SetCollection(GameData::Collections[0], true);
		PlayerModel = GameData::PlayerModels[0];
		TextureMod = "";
	}

	void SetCollection(PreloadingFid@ newCollectionFid, bool forced = false)
	{
		// Do nothing if the collection remains the same
		if (Collection !is null && Collection == newCollectionFid && !forced) {
			return;
		}

		// Get the collection from the fid
		auto newCollection = cast<CGameCtnCollection>(newCollectionFid.Nod);
		if (newCollection is null) {
			error("Fid is not a collection");
			return;
		}

		// Set collection
		@Collection = newCollectionFid;

		// Update list of decorations and clear set default decoration
		GameData::LoadDecorationsForCollection(newCollection);
		if (GameData::Decorations.Length > 0) {
			SetDecoration(GameData::Decorations[0]);
		} else {
			error("No moods found for enviromnent '" + GameData::GetCollectionId(newCollection) + "'!");
			@Decoration = null;
		}

		// Update list of texture mods and clear out current texture mod
		GameData::LoadTextureModsForCollection(newCollection);
		TextureMod = "";
	}

	void SetDecoration(PreloadingFid@ newDecoration)
	{
		@Decoration = newDecoration;

		auto deco = cast<CGameCtnDecoration>(Decoration.Nod);
		DecoSize.x = deco.DecoSize.SizeX;
		DecoSize.y = deco.DecoSize.SizeY;
		DecoSize.z = deco.DecoSize.SizeZ;
	}

	void EditNewMap()
	{
		auto collection = cast<CGameCtnCollection>(Collection.Nod);
		auto collectionId = GameData::GetCollectionId(collection);

		auto deco = cast<CGameCtnDecoration>(Decoration.Nod);

		if (g_decorSize !is null) {
			error("Decor size is expected to be null, but it's not");
		}
		@g_decorSize = deco.DecoSize;

		g_originalSize.x = g_decorSize.SizeX;
		g_originalSize.y = g_decorSize.SizeY;
		g_originalSize.z = g_decorSize.SizeZ;

		g_decorSize.SizeX = DecoSize.x;
		g_decorSize.SizeY = DecoSize.y;
		g_decorSize.SizeZ = DecoSize.z;

		string textureModPath = "";
		if (TextureMod != "") {
			textureModPath = "Skins/" + collectionId + "/Mod/" + TextureMod;
		}

		print("Starting editor");
		trace("- \"" + collectionId + "\"");
		trace("- \"" + deco.IdName + "\"");
		trace("- \"" + textureModPath + "\"");
		trace("- \"" + PlayerModel + "\"");

		CTrackMania@ app = cast<CTrackMania>(GetApp());
#if TURBO
		app.ManiaTitleFlowScriptAPI.EditNewMap(
			collectionId, // "Stadium"
			deco.IdName, // "Day"
			textureModPath, // "Skins/Stadium/Mod/MyMod.zip"
			PlayerModel, // "StadiumCar"
			"RaceCE.Script.txt", "", ""
		);
#else
		app.ManiaTitleControlScriptAPI.EditNewMap2(
			collectionId, // "Stadium"
			deco.IdName, // "Base48x48Day"
			textureModPath, // "Skins/Stadium/Mod/MyMod.zip"
			PlayerModel, // "CarSport"
			"", false, "", ""
		);
#endif
	}
}
