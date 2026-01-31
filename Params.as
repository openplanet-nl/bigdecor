namespace Params
{
	//TODO: Change these to the actual nods instead of strings?

	string Environment;
	string PlayerModel;
	PreloadingFid@ Decoration;
	string TextureMod;
	nat3 DecoSize;

	void Initialize()
	{
		Constants::LoadCollections();
		if (Constants::Collections.Length == 0) {
			error("No environments found!");
			return;
		}

		SetEnvironment(cast<CGameCtnCollection>(Constants::Collections[0].Nod).CollectionId_Text, true);
		PlayerModel = Constants::PlayerModels[0];
		TextureMod = "";
		DecoSize = nat3(48, 40, 48);
	}

	void SetEnvironment(const string &in newEnvironment, bool forced = false)
	{
		// Do nothing if the environment remains the same
		if (Environment == newEnvironment && !forced) {
			return;
		}

		// Set environment
		Environment = newEnvironment;

		// Update list of decorations and clear set default decoration
		Constants::LoadDecorationsForCollection(newEnvironment);
		if (Constants::Decorations.Length > 0) {
			SetDecoration(Constants::Decorations[0]);
		} else {
			error("No moods found for enviromnent '" + newEnvironment + "'!");
			@Decoration = null;
		}

		// Update list of texture mods and clear out current texture mod
		Constants::LoadTextureModsForEnvironment(newEnvironment);
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
		CTrackMania@ app = cast<CTrackMania>(GetApp());
		if (app.ManiaTitleControlScriptAPI is null) {
			return;
		}

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
			textureModPath = "Skins/" + Environment + "/Mod/" + TextureMod;
		}

		print("Starting editor");
		trace("- \"" + Environment + "\"");
		trace("- \"" + deco.IdName + "\"");
		trace("- \"" + textureModPath + "\"");
		trace("- \"" + PlayerModel + "\"");

		app.ManiaTitleControlScriptAPI.EditNewMap2(
			Environment, // "Stadium"
			deco.IdName, // "Base48x48Day"
			textureModPath, // "Skins/Stadium/Mod/MyMod.zip"
			PlayerModel, // "CarSport"
			"", false, "", ""
		);
	}
}
