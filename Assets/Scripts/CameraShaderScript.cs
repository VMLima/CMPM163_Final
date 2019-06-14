using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class CameraShaderScript : MonoBehaviour { 

    public int width = 8;
    public int height = 8;

    public float scale = 10;

    public float offsetX = 0;
    public float offsetY = 0;

    public Texture2D perlinTex;
    //public Material material;
    public Material material;
    // Creates a private material used to the effect
    void Awake() {
        //material = new Material(Shader.Find("Custom/FalseRays"));
    }

    void Update() {
        perlinTex = GenerateTexture();
    }

    // Postprocess the image
    void OnRenderImage(RenderTexture source, RenderTexture destination) {
        material.SetTexture("_noiseTex", perlinTex);
        Graphics.Blit(source, destination, material);
    }

    Texture2D GenerateTexture() {
        Texture2D texture = new Texture2D(width, height);

        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {

                Color color = CalculateColor(x, y);
                texture.SetPixel(x, y, color);

            }
        }
        texture.Apply();
        return texture;
    }

    Color CalculateColor(int x, int y) {
        float xCoord = (float)x / width * scale + offsetX;
        float yCoord = (float)y / height * scale + offsetY;

        float sample = Mathf.PerlinNoise(xCoord, yCoord);
        //float sample = 1;
        return new Color(sample, sample, sample);
    }
}