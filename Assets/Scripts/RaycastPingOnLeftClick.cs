using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RaycastPingOnLeftClick : MonoBehaviour
{
	
	Camera camera;
	public Material pingMaterial;
	public Material chestMaterial;
	public ParticleSystem pingEffect;
	public int bounces = 0;
	public float distance = 0f;
	
	//
	public Texture2D cursorTexture;
    public CursorMode cursorMode = CursorMode.Auto;
    public Vector2 hotSpot = new Vector2(30, 30);
	
	AudioSource sonarPing;
    // Start is called before the first frame update
    void Start()
    {
        camera = GetComponent<Camera>();
		
		Cursor.SetCursor(cursorTexture, hotSpot, cursorMode);
		
	distance = 1000f;
		
		
        sonarPing= GetComponent<AudioSource>();
    }

    // Update is called once per frame
    void Update()
    {
			distance += Time.deltaTime*20;
			pingMaterial.SetFloat("_GlowDistance1", distance);
			chestMaterial.SetFloat("_GlowDistance1", distance);
			if (bounces > 1){
				pingMaterial.SetFloat("_GlowDistance2", distance -1);
			chestMaterial.SetFloat("_GlowDistance2", distance -1);}
			else {
				pingMaterial.SetFloat("_GlowDistance2", -1);
				chestMaterial.SetFloat("_GlowDistance2", -1);
			}
			if (bounces > 2){
				pingMaterial.SetFloat("_GlowDistance3", distance -3);
				chestMaterial.SetFloat("_GlowDistance3", distance -3);
			}
			else {
				pingMaterial.SetFloat("_GlowDistance3", -1);
				chestMaterial.SetFloat("_GlowDistance3", -1);
			}
        if (Input.GetMouseButtonDown(0) && distance > 50)
		{
			sonarPing.Play();
			bounces = 1;
			RaycastHit hit;
			Ray ray = camera.ScreenPointToRay(Input.mousePosition);
			if (Physics.Raycast(ray, out hit)) {
				Vector3 objectHit = hit.point;
				Vector3 pos = hit.point + hit.normal;
				pingMaterial.SetVector("_PingLocation1", new Vector4(pos.x,pos.y,pos.z, 0));
				chestMaterial.SetVector("_PingLocation1", new Vector4(pos.x,pos.y,pos.z, 0));
				distance = 0;
				ParticleSystem p = Instantiate(pingEffect, objectHit, new Quaternion(hit.normal.x,hit.normal.y,hit.normal.z,0));
				Vector3 normal = hit.normal;
				p.transform.LookAt(normal*2f + objectHit);
				
				// shoot second ray reflecting across normal
			Debug.DrawRay(hit.point, normal*1, Color.red, 5);
			Debug.DrawRay(hit.point, Vector3.Reflect(ray.direction, normal)*1, Color.green, 5);

			if (Physics.Raycast(hit.point + 0.001f*normal, Vector3.Reflect(ray.direction, normal), out hit)) {
				bounces++;
				Vector3 objectHit2 = hit.point;
				pos = hit.point + hit.normal;
				pingMaterial.SetVector("_PingLocation2", new Vector4(pos.x,pos.y,pos.z, 0));
				chestMaterial.SetVector("_PingLocation2", new Vector4(pos.x,pos.y,pos.z, 0));
				
				p = Instantiate(pingEffect, objectHit2, new Quaternion(hit.normal.x,hit.normal.y,hit.normal.z,0));
				normal = hit.normal;
				p.transform.LookAt(normal*2f + objectHit2);	
				p.transform.localScale*= 0.5f;
			
			
			
			Debug.DrawRay(hit.point, normal*20, Color.red, 5);
			Debug.DrawRay(hit.point, Vector3.Reflect(ray.direction, normal)*2, Color.green, 5);
			
						if (Physics.Raycast(hit.point + 0.001f*normal, Vector3.Reflect(ray.direction, normal), out hit)) {
							bounces++;
				Vector3 objectHit3 = hit.point;
				pos = hit.point + hit.normal;
				pingMaterial.SetVector("_PingLocation3", new Vector4(pos.x,pos.y,pos.z, 0));
				chestMaterial.SetVector("_PingLocation3", new Vector4(pos.x,pos.y,pos.z, 0));
				
				p = Instantiate(pingEffect, objectHit2, new Quaternion(hit.normal.x,hit.normal.y,hit.normal.z,0));
				normal = hit.normal;
				p.transform.LookAt(normal*2f + objectHit3);	
				p.transform.localScale*= 0.2f;
			
			
			
			Debug.DrawRay(hit.point, normal*20, Color.red, 5);
			Debug.DrawRay(hit.point, Vector3.Reflect(ray.direction, normal)*2, Color.green, 5);
						}
			}
				
				
			}
		
		}
    }
}
