using UnityEngine;
using System.Collections;

[RequireComponent (typeof (SpriteRenderer))]
[ExecuteInEditMode()]
public class NicePathAutoSetter : MonoBehaviour {

	//The sprite meshType should be FullRect

	private float cashedScaleX;
	private float cashedScaleY;
	private float cashedWidth;
	private float cashedHeight;
	private Material ninePatchMaterial;
	private Sprite sprite;


	void Awake(){
	
		SpriteRenderer spriteRenderer = GetComponent<SpriteRenderer> ();
		spriteRenderer.sharedMaterial = new Material(spriteRenderer.sharedMaterial);
		ninePatchMaterial = spriteRenderer.sharedMaterial;
		sprite = spriteRenderer.sprite;
	}

	void Update(){
		float nowScaseX = transform.localScale.x;
		float nowScaseY = transform.localScale.y;
		if (cashedScaleX == nowScaseX && cashedScaleY == nowScaseY) {
			return;
		}
		cashedScaleX = nowScaseX;
		cashedScaleY = nowScaseY;


		ninePatchMaterial.SetFloat("_ImageWidth", sprite.texture.width);
		ninePatchMaterial.SetFloat("_ImageHeight", sprite.texture.height);
		ninePatchMaterial.SetFloat("_WidthTimes", cashedScaleX);
		ninePatchMaterial.SetFloat("_HeightTimes", cashedScaleY);
	}

}
