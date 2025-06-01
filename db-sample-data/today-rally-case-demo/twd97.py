import json
from shapely.geometry import shape, mapping
from shapely.ops import transform
from pyproj import Transformer

# TWD97 TM2 (EPSG:3826) 轉 WGS84 (EPSG:4326)
to_wgs84 = Transformer.from_crs("EPSG:3826", "EPSG:4326", always_xy=True)
to_twd97 = Transformer.from_crs("EPSG:4326", "EPSG:3826", always_xy=True)

def convert_coords(coords):
    # 遞迴處理多層巢狀座標
    if isinstance(coords[0][0], list):
        return [convert_coords(c) for c in coords]
    else:
        return [list(to_wgs84.transform(x, y)) for x, y in coords]

with open('./TodayRallyCase.json', encoding='utf-8') as f:
    data = json.load(f)

buffered_features = []
for feature in data['features']:
    geom = feature['geometry']
    # 先轉成 WGS84
    if geom['type'] == 'Polygon':
        coords_wgs84 = convert_coords(geom['coordinates'])
        poly = shape({"type": "Polygon", "coordinates": coords_wgs84})
    elif geom['type'] == 'MultiPolygon':
        coords_wgs84 = [convert_coords(p) for p in geom['coordinates']]
        poly = shape({"type": "MultiPolygon", "coordinates": coords_wgs84})
    else:
        continue

    # 轉回 TWD97 平面做 buffer
    poly_twd97 = transform(to_twd97.transform, poly)
    buffered_twd97 = poly_twd97.buffer(300)  # 300 公尺
    # 再轉回 WGS84
    buffered_wgs84 = transform(to_wgs84.transform, buffered_twd97)
    feature['geometry'] = mapping(buffered_wgs84)
    buffered_features.append(feature)

out = {
    "type": "FeatureCollection",
    "features": buffered_features
}

with open('./TodayRallyCase_buffer300m.json', 'w', encoding='utf-8') as f:
    json.dump(out, f, ensure_ascii=False, indent=2)
