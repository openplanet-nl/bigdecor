// Maniaplanet and Turbo don't load the map size from the map file itself, so we
// can only support big decors there if Openplanet is installed. This file takes
// care of setting the decor size in time for blocks to be loaded into the right
// positions.

#if MP4 || TURBO
bool g_useNewDecoSize = false;

void OnLoadDecoration(CGameCtnDecoration@ decoration, CGameCtnChallenge@ challenge)
{
	// If the challenge ID is 0xFFFFFFFF, we are creating a brand new map in the
	// editor, so ignore this. In theory, this should not happen due to the check
	// above, but it doesn't hurt having this extra check.
	//
	// Note that in this case, challenge.Size is uninitialized, so we must never
	// use it.
	if (challenge.Id.Value == 0xFFFFFFFF) {
		return;
	}

	trace("Loading decoration");

	RestoreDecoSize();

	auto decoSize = decoration.DecoSize;

	@g_decorSize = decoSize;
	g_decorSize.MwAddRef();
	g_originalSize.x = decoSize.SizeX;
	g_originalSize.y = decoSize.SizeY;
	g_originalSize.z = decoSize.SizeZ;

	bool changed = false;
	auto mapSize = challenge.Size;

#if TURBO
	if (int(decoSize.SizeX) != mapSize.x) { decoSize.SizeX = mapSize.x; changed = true; }
	if (int(decoSize.SizeY) != mapSize.y) { decoSize.SizeY = mapSize.y; changed = true; }
	if (int(decoSize.SizeZ) != mapSize.z) { decoSize.SizeZ = mapSize.z; changed = true; }
#else
	if (decoSize.SizeX != mapSize.x) { decoSize.SizeX = mapSize.x; changed = true; }
	if (decoSize.SizeY != mapSize.y) { decoSize.SizeY = mapSize.y; changed = true; }
	if (decoSize.SizeZ != mapSize.z) { decoSize.SizeZ = mapSize.z; changed = true; }
#endif

	if (changed) {
		trace("Map decor size was set to " + tostring(mapSize));
	}
}
#endif
