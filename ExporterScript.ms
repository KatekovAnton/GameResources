
	Global Object_ 
	
	rollout MeshCompiller "MESH => TXT" width:180 height:145
	(
		
		GroupBox grp1 "Save" pos:[4,7] width:172 height:132
		button Pobj "Save meshes with skins" pos:[11,26] width:160 height:21
		progressBar Sprog "" pos:[11,119] width:154 height:14 
		--#####################################################################--
		fn save f =		(	) 
		--####################################################################--
		fn saveskin f = 		(	)
		--####################################################################--
		--####################################################################--
		fn FindBones =
		(
			bones = #()
			BonesInScene = 0
			for obj in objects do 
				if ((classOf obj) == BoneGeometry) then 
				(
					BonesInScene +=1
					append bones obj
					print obj.Parent
				)
			print BonesInScene 
		)
		
		--####################################################################--
		fn PLZwritestring f str =
		(
			count = str.count as integer
			WriteLong f count
			WriteString f str
		)
		fn PLZwriteSKINstring f str =
		(
			count = str.count as integer
			WriteLong f count
			WriteString f str
			
		)
		fn savebaseskeleton =
		(
		/*	filename = getSaveFileName caption:"Export mesh"
			if filename!=undefined then
			(
				out_file=fopen filename "wb"
				WriteLong out_file 100
				fclose out_file
			)*/
			bones = #()
			BonesInScene = 0
			for obj in objects do 
			(
				if ((classOf obj) == BoneGeometry) then 
				(
					BonesInScene +=1
					append bones obj
					
				)
			)
			if(BonesInScene!=0) then
			(
				filename = getSaveFileName caption:"Export skeleton"
				if filename!=undefined then
				(
					f=fopen filename "wb" 

					WriteLong f BonesInScene
					for bone in bones do
					(
						PLZwritestring f (bone.name as string)
						if(bone.Parent != undefined)then
							PLZwritestring f (bone.Parent.name as string)
						else
							PLZwritestring f "-" as string
					)
					for bone in bones do
					(

					  PLZwritestring out_file (bone.name as string)
					  at time 0 m = (inverse bone.objectTransform)
							  WriteFloat f m[1][1]
							  WriteFloat f m[1][2] 
							  WriteFloat f m[1][3]

							  WriteFloat f m[2][1]
							  WriteFloat f m[2][2] 
							  WriteFloat f m[2][3]

							  WriteFloat f m[3][1]
							  WriteFloat f m[3][2] 
							  WriteFloat f m[3][3]

							  WriteFloat f m[4][1]
							  WriteFloat f m[4][2] 
							  WriteFloat f m[4][3]
					)
					fclose f
				)
			)
			else
				print "no bones in scene"
		)
		fn SaveAnim =
		(
			filename = getSaveFileName caption:"Export animation"
			if filename!=undefined then
			(
				f=fopen filename "wb" 
				bones = #()
				BonesInScene = 0
				for obj in objects do 
					if ((classOf obj) == BoneGeometry) then 
					(
						BonesInScene +=1
						append bones obj
					)
				start = animationRange.start.frame as integer  
				end = animationRange.end.frame as integer 
				
				format "start = %, end = % \n" start end
				WriteLong f start
				WriteLong f end
				counter = 0

				for bone in bones do
				(
				  for frame = start to end do  
					at time frame
					(
						counter +=1
					)
				)
				WriteLong f BonesInScene

				WriteLong f counter
				print counter

				for bone in bones do
				(
				  for frame = start to end do  
					  at time frame
					(	
						  m = bone.objectTransform
						  
						  WriteFloat f m[1][1]
						  WriteFloat f m[1][2] 
						  WriteFloat f m[1][3]

						  WriteFloat f m[2][1]
						  WriteFloat f m[2][2] 
						  WriteFloat f m[2][3]

						  WriteFloat f m[3][1]
						  WriteFloat f m[3][2] 
						  WriteFloat f m[3][3]

						  WriteFloat f m[4][1]
						  WriteFloat f m[4][2] 
						  WriteFloat f m[4][3]
					)
				)
				fclose f
			)
		)
	 	--####################################################################--
 		fn savemesh tmesh out_file = 
		(
			format "\tSaving:     "
			
			num_verts = tmesh.numverts
			num_faces = tmesh.numfaces 
			num_tverts = getNumTVerts tmesh
			WriteLong out_file num_verts
			WriteLong out_file num_faces
			WriteLong out_file num_tverts
			
			
			format "\t> Verts: %          " num_verts
			

			for v=1 to num_verts do
			(
				low = [0.0,0.0,0.0]
				m = [0.0,0.0,0.0]
				normal = [0.0,0.0,0.0]
				normal = getNormal tmesh v
				normal = normalize(normal)
				
				vert = getVert tmesh v
				WriteFloat out_file vert.x
				WriteFloat out_file vert.y
				WriteFloat out_file vert.z
				WriteFloat out_file normal.x
				WriteFloat out_file normal.y
				WriteFloat out_file normal.z

				Sprog.value = v*100/num_verts
			)
			
			format "\t> Faces: %          " num_faces
					
			for f = 1 to num_tverts do
			(
				tvert = getTVert tmesh f
				WriteFloat out_file tvert.x
				WriteFloat out_file tvert.y
			)
			for f=1 to num_faces do
			(
				tface = getTVFace tmesh f
				face = getFace tmesh f
				WriteLong out_file face.x
				WriteLong out_file face.y
				WriteLong out_file face.z
				WriteLong out_file tface.x
				WriteLong out_file tface.y
				WriteLong out_file tface.z
				Sprog.value = F*100/num_faces
			)
 
		)
		--####################################################################--
		fn saveSSskin obj out_file = 
		(
			
			theskin = 0

			for i in obj.modifiers do
			(
				if classof(i)==Skin then
				(
					theskin =  i
					format "> Skin...\n"
					exit
				)
			)
			max modify mode
			
			
			
			if(theskin !=0) then
			(
				modPanel.setCurrentObject theskin
				vv = skinOps.GetNumberVertices theskin
				WriteLong out_file vv
				bb = skinOps.GetNumberBones theskin
				WriteLong out_file bb
				print "<<<<<<<Skin saving...>>>>>>>"
				for ivert = 1 to (SkinOps.GetNumberVertices theskin) do
				(	
					vwc = skinOps.GetVertexWeightCount theskin ivert
					Count = vwc as integer
					for ivertbone = 1 to (vwc) do
					(
						Tweight = skinOps.GetVertexWeight theskin ivert ivertbone
						if Tweight <0.1 then
							Count = Count-1
					)
					WriteLong out_file Count
					for ivertbone = 1 to (vwc) do
					(
						bone_id = skinOps.GetBoneName theskin (skinOps.getVertexWeightBoneID theskin ivert ivertbone) 0
						weight = skinOps.GetVertexWeight theskin ivert ivertbone
						if weight >0.1 then
						(
							PLZwriteSKINstring out_file (bone_id as string)
							WriteFloat out_file weight
						)
					)
				)
			)
			else
			(
				WriteLong out_file 0
				WriteLong out_file 0
			)

		)
		
		global f = 0
		global OFFSET =0

		fn writeshapka f = 
		(
			OFFSET = 0
			for obj in objects do 
			(
				
				
					if( (ClassOf obj != BoneGeometry) and (ClassOf obj != Particle_View ))then
					(
						tmesh = SnapShotAsMesh obj
						
						headerlength = 16 + (obj.name.count as integer)
						headerlength +=8
						
						theskin = 0
						for i in obj.modifiers do
						(
							if classof(i)==Skin then
							(
								theskin =  i
								exit
							)
						)
						
						max modify mode
						PLZwritestring f (obj.name as string)
						WriteLong f OFFSET
						
						
						
						num_verts = tmesh.numverts
						num_faces = tmesh.numfaces 
						num_tverts = getNumTVerts tmesh
						OFFSET += 12
						OFFSET += num_verts*24
						OFFSET += num_tverts*8
						OFFSET += num_faces*24
						skinsize = 0;
						if(theskin !=0) then
						(
							modPanel.setCurrentObject theskin
							skinsize += 8

							for ivert = 1 to (SkinOps.GetNumberVertices theskin) do
							(	
								vwc = skinOps.GetVertexWeightCount theskin ivert
								Count = vwc as integer
								for ivertbone = 1 to (vwc) do
								(
									Tweight = skinOps.GetVertexWeight theskin ivert ivertbone
									if Tweight <0.1 then
										Count = Count-1
								)
								skinsize += 4
								for ivertbone = 1 to (vwc) do
								(
									bone_id = skinOps.GetBoneName theskin (skinOps.getVertexWeightBoneID theskin ivert ivertbone) 0
									weight = skinOps.GetVertexWeight theskin ivert ivertbone
									if weight >0.1 then
									(
										skinsize += 8
										bname = bone_id as string;
										skinsize += bname.count+1
									)
								)
							)
						)
						else
						(
							skinsize += 8
						)--if(theskin !=0)
	--###############################################################
						
						WriteLong f 0
						WriteLong f headerlength 
						WriteLong f 1
						WriteLong f skinsize 
						WriteLong f 0
	--###############################################################
						
						OFFSET += skinsize 
					)--if ClassOf obj != BoneGeometry
					
			)--for obj in objects do
	
		
		)--fn writeshapka
		--####################################################################--
		fn proceedallsubsets = 
		(
			savebaseskeleton()
			filename = getSaveFileName caption:"Export mesh"
			if filename!=undefined then
			(
				f=fopen filename "wb" 
				objcount = 0
				for obj in objects do 
				(
					if( (ClassOf obj != BoneGeometry) and (ClassOf obj != Particle_View ) )then
					(
						objcount +=1
					)
				)
				WriteLong f 43647457
				WriteLong f objcount 
				
				writeshapka f

				
				for obj in objects do
				(
				fffd = "\t%\t"
				format "%" (ClassOf obj)
					if (obj.name.count<4) then fffd = fffd+"\t"
					if (obj.name.count<=11) then fffd = fffd+"\t"
					if (obj.name.count<8) then fffd = fffd+"\t"
					
				format fffd obj.name

				
						if ((ClassOf obj != BoneGeometry) and (ClassOf obj != Particle_View ) )then
						(
							tmesh = SnapShotAsMesh obj
							savemesh tmesh f
							saveSSskin obj f
						)
						format "  ... OK   \n"
					) 
					
				)
				fclose f 
			)
		
		--####################################################################--
		button btn4 "Save animation" pos:[10,60] width:160 height:21
		
		on MeshCompiller open do
		(		clearListener() )
		
		on Pobj pressed do
		(
			--FindBones()
			print "################################################################################################################################"
			print "                                                                Begin Saving...."
			print "################################################################################################################################\n"
			proceedallsubsets()
			print "\n################################################################################################################################"
			print "                                                           All Saving Succesfully!!!"
			print "################################################################################################################################\n\n\n\n"
		)
		on btn4 pressed  do
		(
			SaveAnim()
		)
	)	
	CreateDialog MeshCompiller
	/*
			--Binary--
			f=fopen "c:\\test.bin" "wb" 
			WriteString f "String" 
			WriteByte f 64 
			WriteShort f 128 
			WriteLong f 256 
			WriteFloat f 512.0 
			WriteString f "gnirtS" 
			WriteLong f (ftell f) 
			fclose f 
			f=fopen "c:\\test.bin" "rb" 
			ReadString f 
			ReadByte f 
			ReadShort f 
			ReadLong f 
			ReadFloat f 
			ReadString f 
			ftell f 		
			fclose f
			*/