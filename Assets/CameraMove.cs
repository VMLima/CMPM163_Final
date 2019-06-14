using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraMove : MonoBehaviour {

    public Vector3 pos1;
    public Vector3 pos2;
    public Vector3 angle1;
    public Vector3 angle2;
    public float speed;
    // Start is called before the first frame update
    void Start() {
        
    }

    // Update is called once per frame
    void Update() {
        transform.position = Vector3.Lerp(pos1, pos2, Mathf.PingPong(Time.time * speed, 1.0f));
        transform.eulerAngles = Vector3.Lerp(angle1, angle2, Mathf.PingPong(Time.time * speed, 1.0f));
    }
}
