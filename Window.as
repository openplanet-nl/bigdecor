namespace Window
{
	bool Visible = false;

	void Render()
	{
		int windowFlags = UI::GetDefaultWindowFlags() | UI::WindowFlags::NoResize | UI::WindowFlags::AlwaysAutoResize;
		if (UI::Begin("\\$cf9" + Icons::Map + "\\$z Create a new map##Create a new map", Visible, windowFlags)) {
			if (UI::IsWindowAppearing()) {
				Params::Initialize();
			}

			RenderContents();
		}
		UI::End();
	}

	void RenderContents()
	{
		// Require users to not be in a map
		if (GetApp().RootMap !is null) {
			UI::Text("Return to the main meun to create a new map.");
			return;
		}

		UI::SeparatorTextOpenplanet("\\$cf9" + Icons::Tree + "\\$z Environment");

		// Collection
		UI::PushID("Collection");
		Params::Collection.RenderDebug();
		if (UI::BeginCombo("Collection", GetNameForCollection(Params::Collection))) {
			for (uint i = 0; i < Constants::Collections.Length; i++) {
				auto collectionFid = Constants::Collections[i];
				auto collection = cast<CGameCtnCollection>(collectionFid.Nod);
				if (!Setting_ShowStadium256 && collection.CollectionId_Text == "Stadium256") {
					continue;
				}
				if (UI::Selectable(GetNameForCollection(collection), collectionFid == Params::Collection)) {
					Params::SetCollection(collectionFid);
				}
			}

			UI::EndCombo();
		}
		UI::PopID();

		// Decoration
		UI::PushID("Decoration");
		Params::Decoration.RenderDebug();
		auto currentDeco = cast<CGameCtnDecoration>(Params::Decoration.Nod);
		if (UI::BeginCombo("Decoration", currentDeco.IdName)) {
			for (uint i = 0; i < Constants::Decorations.Length; i++) {
				auto pfid = Constants::Decorations[i];
				auto deco = cast<CGameCtnDecoration>(pfid.Nod);
				if (UI::Selectable(deco.IdName, currentDeco.IdName == deco.IdName)) {
					Params::SetDecoration(pfid);
				}
			}
			UI::EndCombo();
		}
		UI::PopID();

		// Player model
		if (UI::BeginCombo("Player model", GetNameForPlayerModel(Params::PlayerModel))) {
			for (uint i = 0; i < Constants::PlayerModels.Length; i++) {
				string playerModel = Constants::PlayerModels[i];
				if (UI::Selectable(GetNameForPlayerModel(playerModel), playerModel == Params::PlayerModel)) {
					Params::PlayerModel = playerModel;
				}
			}
			UI::EndCombo();
		}

		// User mod
		if (Constants::TextureMods.Length > 0) {
			if (UI::BeginCombo("Texture mod", Params::TextureMod == "" ? "\\$666(none)" : Params::TextureMod)) {
				if (UI::Selectable("\\$666(none)", Params::TextureMod == "")) {
					Params::TextureMod = "";
				}
				for (uint i = 0; i < Constants::TextureMods.Length; i++) {
					string mod = Constants::TextureMods[i];
					if (UI::Selectable(mod, mod == Params::TextureMod)) {
						Params::TextureMod = mod;
					}
				}
				UI::EndCombo();
			}
		}

		UI::SeparatorTextOpenplanet("\\$fc9" + Icons::Cube + "\\$z Properties");

		// Dimensions
		Params::DecoSize.x = UI::SliderInt("Size X", Params::DecoSize.x, 1, 255, "%d", UI::SliderFlags::AlwaysClamp);
		Params::DecoSize.y = UI::SliderInt("Size Y (height)", Params::DecoSize.y, 1, 255, "%d", UI::SliderFlags::AlwaysClamp);
		Params::DecoSize.z = UI::SliderInt("Size Z", Params::DecoSize.z, 1, 255, "%d", UI::SliderFlags::AlwaysClamp);

		// Buttons
		if (UI::Button(Icons::PlusCircle + " Create map")) {
			Params::EditNewMap();
			Visible = false;
		}
		//todo: randomize button
	}

	string GetNameForCollection(PreloadingFid@ collectionFid)
	{
		auto collection = cast<CGameCtnCollection>(collectionFid.Nod);
		return GetNameForCollection(collection);
	}

	string GetNameForCollection(CGameCtnCollection@ collection)
	{
		auto collectionId = collection.CollectionId_Text;
		if (collectionId == "Stadium") {
			return "\\$fd3" + Icons::Flag + "\\$z Stadium";
		} else if (collectionId == "GreenCoast") {
			return "\\$493" + Icons::Flag + "\\$z Green Coast";
		} else if (collectionId == "RedIsland") {
			return "\\$d21" + Icons::Flag + "\\$z Red Island";
		} else if (collectionId == "BlueBay") {
			return "\\$36d" + Icons::Flag + "\\$z Blue Bay";
		} else if (collectionId == "WhiteShore") {
			return "\\$5de" + Icons::Flag + "\\$z White Shore";
		}
		return collectionId;
	}

	string GetNameForPlayerModel(const string &in playerModel)
	{
		if (playerModel == "CarSport") {
			return "Stadium Car";
		} else if (playerModel == "CarSnow") {
			return "Snow Car";
		} else if (playerModel == "CarRally") {
			return "Rally Car";
		} else if (playerModel == "CarDesert") {
			return "Desert Car";
		} else if (playerModel == "CharacterPilot") {
			return "Pilot Character";
		}
		return playerModel;
	}
}
