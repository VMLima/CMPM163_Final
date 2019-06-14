using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GenerateField : MonoBehaviour {

	public int size = 10;
	public GameObject grassCube;

	// Use this for initialization
	
	void Start () {
		for (int i = -size; i < size; i++ ){
			for (int j = -size; j< size; j++ ){
				GameObject cube = Instantiate(grassCube, new Vector3(i*60, 0, j*60), Quaternion.identity);
				cube.transform.Rotate(new Vector3(-90f, 0f, 0f));
				
			}
		}
	}
	
	// Update is called once per frame
	void Update () {
		
	}
}
