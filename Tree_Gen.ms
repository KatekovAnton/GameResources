/* 

	TreeGen for 3DSMax written by Ryan James Smith aka "Virtuosic" on polycount forums.


	This is creative commons, edit and redistribute as you please, just remember to give original credit
	also, if you add some cool stuff, email me at virtuosicrjs@gmail.com and let me know what you did so 
	i can be jealous i didn't think of it... Oh, and if you add something cool, sign your name below mine :D
	
*/





macroscript TreeGenerator category:"Tree Generator" tooltip:"TreeGen Beta v0.97"
(
	-- Declare Global Variables 
	global trunkspline
	global trunkmesh
	global branchArray = #()
	global branchMeshArray = #()
	global leavesArray = #() -- a container holding the leaf reference mesh(s)
	global leafMeshArray = #() -- the array of copied leaf meshes that actually get placed on the tree
	global canEdit = false
	

	

rollout TreeGen "TreeGen Beta v.097" width:648 height:440
(
	
	spinner trunkHeight "" pos:[96,16] width:48 height:16 enabled:false range:[0,4096,350] scale:1
	spinner trunkSides "" pos:[96,64] width:48 height:16 enabled:false range:[0,32,8] type:#integer scale:1
	spinner TrunkBendAngle "" pos:[96,184] width:48 height:16 enabled:false range:[-180,180,0] type:#integer scale:1
	spinner TrunkBendDir "" pos:[96,208] width:48 height:16 enabled:false range:[-360,360,0] type:#integer scale:1
	spinner TrunkNoiseStrength "" pos:[96,232] width:48 height:16 enabled:false range:[-100,100,10] scale:1
	spinner TrunkNoiseScale "" pos:[96,256] width:48 height:16 enabled:false range:[0,1000,50] type:#integer scale:1
	spinner trunkNoiseSeed "" pos:[96,280] width:48 height:16 enabled:false range:[0,10000,4331] type:#integer scale:1
	spinner trunkSegs "" pos:[96,88] width:48 height:16 enabled:false range:[0,128,12] type:#integer scale:1
	spinner trunkRadius "" pos:[96,41] width:48 height:16 enabled:false range:[0,256,16] type:#float scale:1
	spinner trunkPinch "" pos:[96,136] width:48 height:16 enabled:false range:[0,1,0.9] type:#float scale:0.01
	spinner trunkPinchCurve "" pos:[96,160] width:48 height:16 enabled:false range:[-10,10,0.5] scale:0.1
	spinner trunkTextureTile "" pos:[96,112] width:48 height:16 enabled:false range:[0,100,4] type:#float scale:0.1
	spinner stretchAmount "" pos:[96,304] width:48 height:16 enabled:false range:[0,100,1] type:#float scale:0.01
	spinner twistAmount "" pos:[96,328] width:48 height:16 enabled:false range:[-1000,1000,-180] type:#float scale:1
	spinner trunkSpiral "" pos:[96,352] width:48 height:16 enabled:false range:[-2000,2000,1] type:#float scale:1
	spinner branchPercent "" pos:[265,16] width:48 height:16 enabled:false range:[0,99.9,30] type:#float scale:0.1
	spinner branchNumber "" pos:[265,40] width:48 height:16 enabled:false range:[0,100,8] type:#integer scale:1
	spinner branchLength "" pos:[264,136] width:48 height:16 enabled:false range:[0,2000,350] type:#float scale:1
	spinner branchSegs "" pos:[265,160] width:48 height:16 enabled:false range:[0,128,6] type:#float scale:1
	spinner branchNoise "" pos:[264,184] width:48 height:16 enabled:false range:[-100,100,10] type:#float scale:1
	spinner branchNoiseScale "" pos:[264,208] width:48 height:16 enabled:false range:[0,1000,50] type:#float scale:1
	spinner branchNoiseSeed "" pos:[264,232] width:48 height:16 enabled:false range:[0,10000,1215] type:#float scale:1
	spinner rotOffset "" pos:[264,256] width:48 height:16 enabled:false range:[-2000,2000,64] type:#float scale:1
	spinner tiltAmount "" pos:[264,280] width:48 height:16 enabled:false range:[-90,90,-30] type:#float scale:1
	spinner tiltVariation "" pos:[331,280] width:40 height:16 enabled:false range:[0,90,0] type:#float scale:1
	spinner branchTwist "" pos:[265,352] width:48 height:16 enabled:false range:[-1000,1000,-90] type:#float scale:1
	spinner branchRadius "" pos:[265,65] width:48 height:16 enabled:false range:[0,256,8] type:#float scale:1
	spinner branchPinchCurve "" pos:[265,304] width:48 height:16 enabled:false range:[0,1,0] scale:0.01	
	
	
	
	
	spinner branchSides "" pos:[265,88] width:48 height:16 enabled:false range:[0,32,5] type:#integer scale:1
	spinner branchUVScale "" pos:[265,112] width:48 height:16 enabled:false range:[0,100,4] type:#float scale:0.1
	spinner branchStretch "" pos:[265,327] width:48 height:16 enabled:false range:[0,100,1] type:#float scale:0.01
	spinner leavesPerBranch "" pos:[513,128] width:48 height:16 enabled:false range:[0,100,20] type:#integer scale:1
	spinner leafRotStep "" pos:[513,176] width:48 height:16 enabled:false range:[-720,720,100] type:#float scale:1
	spinner leafRotVariation "" pos:[584,176] width:40 height:16 enabled:false range:[0,180,0] type:#float scale:1
	spinner LeafTilt "" pos:[513,200] width:48 height:16 enabled:false range:[-90,90,50] type:#float scale:1
	spinner LeafTiltVariation "" pos:[584,200] width:40 height:16 enabled:false range:[0,90,0] type:#float scale:1
	spinner leafScaleVariation "" pos:[584,224] width:40 height:16 enabled:false range:[0,10,0] type:#float scale:0.01
	spinner leafScale "" pos:[513,224] width:48 height:16 enabled:false range:[0,100,1] type:#float scale:0.01
	spinner leafBunch "" pos:[513,152] width:48 height:16 enabled:false range:[1,100,1] type:#float scale:0.1
	spinner leafOffset "" pos:[513,248] width:48 height:16 enabled:false range:[0,100,0] type:#float scale:0.1
	
	listbox lb_leafBranches "" pos:[393,16] width:240 height:4 readOnly:true

	button btn_bakeTree "Bake Tree" pos:[161,384] width:216 height:48 enabled:false
	button btn_addSelection "Add Selection" pos:[393,80] width:112 height:16
	button btn_clearSelection "Clear " pos:[521,80] width:112 height:16
	button btn_generateTree "Generate Tree" pos:[8,384] width:144 height:48
	button btn_hideTrunk "Hide Trunk" pos:[392,280] width:240 height:24 enabled:false
	button btn_hideBranches "Hide Branches" pos:[392,312] width:240 height:24 enabled:false
	button btn_hideLeaves "Hide Leaves" pos:[392,344] width:240 height:24 enabled:false
	
	materialButton btn_BarkMaterial "Choose Bark Material" pos:[391,392] width:241 height:32

	label lbl325 "+ -" pos:[563,224] width:16 height:16
	label lbl287 "+ -" pos:[563,200] width:16 height:16
	label lbl288 "Leaf Tilt" pos:[473,200] width:40 height:16		
		
		
		
	label lbl348 "Leaf Offset" pos:[456,248] width:57 height:16
		
	label lbl191 "Leaf Bunch %" pos:[443,152] width:69 height:16
	label lbl285 "Leaf Rotation Step" pos:[422,176] width:90 height:16
	label lbl286 "+ -" pos:[562,176] width:16 height:16
	label lbl326 "Leaf Scale" pos:[464,224] width:49 height:16
	label lbl220 "Base Branch Leaf Count" pos:[397,128] width:116 height:16
	label lbl76 "Sides" pos:[225,88] width:40 height:16
	label lbl77 "Radius" pos:[225,64] width:40 height:16
	label lbl79 "Pinch Curve" pos:[207,304] width:58 height:16
	label lbl59 "UV Tile" pos:[225,112] width:40 height:16
	label lbl60 "Branch Stretch" pos:[193,328] width:72 height:16
	label lbl61 "Branch Twist" pos:[199,352] width:66 height:16
	label lbl143 "Tilt" pos:[248,280] width:16 height:16
	label lbl142 "Base Branch Length" pos:[168,136] width:96 height:16
	label lbl140 "Branch Start %" pos:[185,16] width:80 height:16
	label lbl141 "# of Branches" pos:[185,40] width:80 height:16
	label lbl_height "Height" pos:[56,16] width:40 height:16
	label lbl111 "Radius" pos:[56,40] width:40 height:16
	label lbl112 "Sides" pos:[56,64] width:40 height:16
	label lbl113 "Height Segments" pos:[13,88] width:83 height:16
	label lbl114 "UV Tile" pos:[56,112] width:40 height:16
	label lbl115 "Pinch" pos:[56,136] width:40 height:16
	label lbl116 "Pinch Curve" pos:[32,160] width:64 height:16
	label lbl117 "Bend Angle" pos:[32,184] width:64 height:16
	label lbl118 "Bend Direction" pos:[16,208] width:80 height:16
	label lbl119 "Noise Strength" pos:[24,232] width:72 height:16
	label lbl120 "Noise Scale" pos:[32,256] width:64 height:16
	label lbl121 "Noise Seed" pos:[32,280] width:64 height:16
	label lbl122 "Trunk Stretch" pos:[24,304] width:72 height:16
	label lbl_twist "Twist" pos:[56,328] width:40 height:16
	label lbl124 "Spiral" pos:[56,352] width:40 height:16
	label lbl50 "+ -" pos:[313,280] width:16 height:16
	label lbl51 "Branch Segments" pos:[176,160] width:88 height:16
	label lbl73 "Branch Noise" pos:[200,184] width:64 height:16
	label lbl74 "Branch Noise Scale" pos:[169,208] width:92 height:16
	label lbl75 "Branch Noise Seed" pos:[172,232] width:89 height:16
	label lbl_rotOffset "Rotation Offset" pos:[187,256] width:75 height:16
	
	GroupBox grp1 "Trunk Controls" pos:[8,0] width:144 height:376
	GroupBox grp4 "Branch Controls" pos:[160,0] width:216 height:376
	GroupBox grp3 "Materials" pos:[383,376] width:256 height:56
	GroupBox grp19 "Leaf Meshes" pos:[385,0] width:256 height:104
	GroupBox grp5 "Leaf Controls" pos:[384,112] width:256 height:160
	



		-- functions specific to this rollout
	
	-- this function updates the mesh everytime one of the sliders is changed.
fn addPathConstraint spline obj =
	(	
		pConstraint = Path_Constraint()
		pConstraint.path = spline
		obj.pos.controller = pConstraint
		return pConstraint
	)	
	
fn simpleSpline splineLength splineSegs = 
	(
		newSpline = SplineShape pos:[0,0,0]
		addNewSpline newSpline
		addKnot newSpline 1 #corner #line [0,0,0]
		addKnot newSpline 1 #corner #line [0,0,splineLength]
		updateShape newSpline
		
		subdivideSegment newSpline 1 1 (splineSegs - 2) -- Use to determine how many verts our spline has
				knots = numknots newSpline
		for i = 1 to knots do -- iterate over each knot in spline
			(
				setKnotType newSpline 1 i #corner -- set each knot in the spline to type #corner
			)
			
		return newSpline
	)
	
fn generateTrunk TreeGenUI   = 
	(
		ss = simpleSpline TreeGenUI.trunkHeight.value TreeGenUI.trunkSegs.value
		
		trunkNoise = noisemodifier() -- noise Modifier
		addModifier ss trunkNoise
		trunkNoise.scale = TreeGenUI.TrunkNoiseScale.value
		trunkNoise.strength = [TreeGenUI.TrunkNoiseStrength.value, TreeGenUI.TrunkNoiseStrength.value, 0]
		trunkNoise.seed = TreeGenUI.trunkNoiseSeed.value	

		trunkBend = bend()--add Bend Modifier
		addModifier ss trunkBend
		trunkbend.angle = TreeGenUI.TrunkBendAngle.value -- Angle
		trunkbend.direction = TreeGenUI.TrunkBendDir.value -- direction (degrees)
		
		trunkTwist = Twist()
		addmodifier ss trunkTwist
		trunkTwist.Angle = TreeGenUI.trunkSpiral.value
		
		editTrunkSpline = Edit_Spline()
		addmodifier ss editTrunkSpline 

		return ss
	)
	


fn generateTrunkMesh TreeGenUI= 
	(
		-- Add cylinder to a scene and set it's basic params.
		cyl = cylinder()
		if TreeGen.btn_barkmaterial.material == undefined then
		(
			defaultMat = standardMaterial()
			cyl.material = defaultMat
		)
		else
		(
			cyl.material = TreeGen.btn_barkmaterial.material
		)
		cyl.radius = TreeGenUI.trunkRadius.value
		cyl.pos = [0,0,0]
		cyl.sides = TreeGenUI.trunkSides.value
		cyl.height = TreeGenUI.trunkHeight.value
		cyl.heightsegments = (TreeGenUI.trunkSegs.value - 1) 
		
		--add a uvw map to the cylinder and tweak it's basic params.
		cylUV = uvwmap()
		addmodifier cyl cylUV
		cylUV.maptype = 1
		cylUV.vtile = TreeGenUI.trunkTextureTile.value
		
		-- add a Taper modifier to the cylinder and tawek it's basic params
		cylTaper = taper()
		addmodifier cyl cylTaper
		cylTaper.amount = -TreeGenUI.trunkPinch.value
		cylTaper.curve = -TreeGenUI.trunkPinchCurve.value
		
		-- add a Path Deform to the cylidner and tweak it's basic params.
		cylDeform = SpacePathDeform()
		addmodifier cyl cylDeform
		cylDeform.path = trunkSpline
		cylDeform.Stretch = TreeGenUI.stretchAmount.value
		cylDeform.Twist = treeGenUI.twistAmount.value
		
		trunkPoly = edit_poly()
		addmodifier cyl trunkPoly
		
		return cyl -- returns the node
	)
	
	fn generateBranchMesh branch height radius TreeGenUI = 
	(
		-- Add cylinder to a scene and set it's basic params.
		cyl = cylinder()
		if TreeGen.btn_barkmaterial.material == undefined then
		(
			defaultMat = standardMaterial()
			cyl.material = defaultMat
		)
		else
		(
			cyl.material = TreeGen.btn_barkmaterial.material
		)
		cyl.radius = radius
		cyl.pos = [0,0,0]
		cyl.sides = TreeGenUI.branchSides.value
		cyl.height = height
		cyl.heightsegments = (TreeGenUI.branchSegs.value - 1) 
		
		--add a uvw map to the cylinder and tweak it's basic params.
		cylUV = uvwmap()
		addmodifier cyl cylUV
		cylUV.maptype = 1
		cylUV.vtile = TreeGenUI.branchUVScale.value
		
		-- add a Taper modifier to the cylinder and tawek it's basic params
		cylTaper = taper()
		addmodifier cyl cylTaper
		cylTaper.amount = -1
		cylTaper.curve = -TreeGenUI.branchPinchCurve.value
		
		-- add a Path Deform to the cylidner and tweak it's basic params.
		cylDeform = SpacePathDeform()
		addmodifier cyl cylDeform
		--cylDeform.Flip_deformation_axis = 1
		cylDeform.path = branch
		cylDeform.Twist = TreeGenUI.branchTwist.value
		cylDeform.Stretch = TreeGenUI.branchStretch.value
		
		return cyl -- returns the node
	)
	
	fn createBranches TreeGenUI =
	(
		branchArray = undefined
		
		branchArray =#()
		
		for i = 1 to TreeGenUI.branchNumber.value do 	-- This code will be used to create each branch.
		(
				
				-- Determine what percentage up the trunk this branch will be placed.
				offset = ((100 - TreeGenUI.branchPercent.value)/TreeGenUI.branchNumber.value ) * (i - 1)
				percentage = TreeGenUI.branchPercent.value - 100 + offset
				newLength = TreeGenUI.branchLength.value * (percentage/100) * -1
				newRadius = TreeGenUI.branchRadius.value * (percentage/100) * 1.5
			
				branchSpline = simpleSpline newLength TreeGenUI.branchSegs.value -- create our spline for the branch
				
				knotArray = for i = 2 to TreeGenUI.branchSegs.value collect i -- create an array of knots that exclude the knot attached to the trunk spline. This will ensure that the root knot does not get offset from the path by any noise modifiers.
				setknotselection branchspline 1 knotArray
				
				branchMesh = generateBranchMesh branchSpline newLength -newRadius TreeGenUI
				branchMesh.parent = branchSpline
				
				
				-- handles rotation of the branch
				branchSpline.dir = [1,0,0]
				zRot = eulerangles 0 0 ((360/TreeGenUI.branchNumber.value + TreeGenUI.rotOffset.value) * i) 
				tiltRot = eulerangles (TreeGenUI.tiltAmount.value + random -TreeGenUI.tiltVariation.value TreeGenUI.tiltVariation.value) 0 0 
				rotate branchSpline zRot
				in coordsys local rotate branchSpline tiltRot
			
				pConstraint = addPathConstraint trunkSpline branchSpline -- add a path constraint to our spline, and attach it to our trunk
				pConstraint.percent = percentage -- apply percentag along trunk to constraint.
				
				branchSplineNoise = noisemodifier() -- create a noise modifier for our spline
				addModifier branchSpline branchSplineNoise
				branchSplineNoise.scale = TreeGenUI.branchNoiseScale.value
				branchSplineNoise.strength = [TreeGenUI.branchNoise.value, TreeGenUI.branchNoise.value, 0]
				branchSplineNoise.seed = TreeGenUI.branchNoiseSeed.value

				editBranchSpline = edit_spline()
				addmodifier branchSpline editBranchSpline
				
				append branchArray branchSpline -- add our new branch spline to the branch Array
				append branchMeshArray branchMesh
		)
	
		--return branchArray 
	)
	

	
	fn placeLeafMeshes TreeGenUI=
	(
		leafMeshArray = #()
		
		if TreeGenUI.lb_leafBranches.items[1] != undefined do
		(
		
			for i = 1 to branchArray.count do
			(
				branchOffset = ((100 - TreeGenUI.branchPercent.value)/TreeGenUI.branchNumber.value ) * (i - 1)
				branchPercentage = TreeGenUI.branchPercent.value - 100 + branchOffset
				--newLength = TreeGen.branchLength.value * (percentage/100)
				--NewLeafSize = LeafSize * (percentage/100)
				leafMeshesOnBranch = ceil (TreeGenUI.leavesPerBranch.value * (branchPercentage/100)) * -1
		
				for j = 1 to leafMeshesOnBranch as integer do -- This codeblock is executed for every leaf mesh... try to keep it clean and concise! 
				(
				try 	newleaf = copy leavesArray[((mod (j-1) leavesArray.count) + 1) as integer] 
				catch
					(
						messagebox "You can't add leaves from the active tree to the Leaf Meshes box, please select a different mesh"
					)
					
					leafConstraint = addPathConstraint branchArray[i] newleaf
					leafConstraint.percent =  ((100/leafMeshesOnBranch) * j)/TreeGenUI.leafBunch.value + TreeGenUI.leafOffset.value
					leafConstraint.follow = true
					leafConstraint.axis = 2
					
					randomScale = random -TreeGen.leafScaleVariation.value TreeGen.leafScaleVariation.value
					leafScaleVal = [randomScale, randomScale, randomScale] 
					 
					newleaf.scale = ([TreeGenUI.leafScale.value, TreeGenUI.leafScale.value, TreeGenUI.leafScale.value] + leafScaleVal)
					
					yRot = eulerangles 0 ((j*TreeGenuI.leafRotStep.value) + random -TreeGenUI.leafRotVariation.value TreeGenUI.leafRotVariation.value) 0
					xRot = eulerangles (TreeGenUI.LeafTilt.value + random -TreeGenUI.LeafTiltVariation.value TreeGenUI.LeafTiltVariation.value) 0 0 
					in coordsys local rotate newleaf yRot
					in coordsys local rotate newleaf xRot
					
					append leafMeshArray newleaf
				)
			)
		) 
	)		
	
fn updateTrunk = 
	(
		gc()
		
		deselect selection
		
		--For the Trunk Spline
		if isvalidnode trunkSpline == true then 
			(
				delete TrunkSpline
				TrunkSpline = undefined
			)
			else trunkSpline = undefined
		trunkSpline = generateTrunk TreeGen
		
		
		-- For the Trunk's Mesh
		if isvalidnode trunkMesh == true then 
		(
			delete trunkMesh
			trunkMesh = undefined
		)
			else trunkMesh = undefined
		trunkMesh = generateTrunkMesh TreeGen
		
		--For the Branches
		if isvalidnode branchArray[1] == true and isvalidnode branchMeshArray[1] == true then 
		(
			for i in branchArray do
			( if isvalidnode i == true do delete i )
			
			for i in branchMeshArray do
			( if isvalidnode i == true do delete i )
			
			branchMeshArray = #()
			branchArray = #()
		)
		else 
		(
			branchArray = #()
			branchMeshArray = #()
		)
			
		createBranches TreeGen
		
		
		-- For the Leaves
		if isvalidnode leafMeshArray[1] == true then
		(
			for i in leafMeshArray do 
			( if isvalidnode i == true do delete i )
			leafMeshArray = #()
		)
			else leafMeshArray = #()
			placeLeafMeshes TreeGen
		--For the Horde! 
	)	
	
	fn bakeTree  =
	(	 
		trunkBake = snapshot trunkMesh
	
		for i in branchMeshArray do
		(
			branchBake = snapshot i
			branchbake.pos = [0,0,0]
			branchBake.parent = trunkbake
		)
		
		for i = 1 to leafMeshArray.count do
		(
			leafBake = snapshot leafMeshArray[i]
			leafBake.parent = trunkbake
		)
		
		delete branchArray
		delete trunkMesh
		delete branchMeshArray
		delete leafMeshArray
		delete trunkSpline
		
		trunkSpline = undefined
		trunkMesh = undefined
		leafMeshArray = #()
		branchArray = #()
		branchMeshArray = #()
		
	)
	
	on trunkHeight changed val do
		updateTrunk()
	on trunkSides changed val do
		updateTrunk()
	on TrunkBendAngle changed val do
		updateTrunk()
	on TrunkBendDir changed val do
		updateTrunk()
	on TrunkNoiseStrength changed val do
		updateTrunk()
	on TrunkNoiseScale changed val do
		updateTrunk()
	on trunkNoiseSeed changed val do
		updateTrunk()
	on trunkSegs changed val do
		updateTrunk()
	on trunkRadius changed val do
		updateTrunk()
	on trunkPinch changed val do
		updateTrunk()
	on trunkPinchCurve changed val do
		updateTrunk()
	on trunkTextureTile changed val do
		updateTrunk()
	on stretchAmount changed val do
		updateTrunk()
	on twistAmount changed val do
		updateTrunk()
	on trunkSpiral changed val do
		updateTrunk()
	on branchPercent changed val do
		updateTrunk()
	on branchNumber changed val do
		updateTrunk()
	on branchLength changed val do
		updateTrunk()
	on branchSegs changed val do
		updateTrunk()
	on branchNoise changed val do
		updateTrunk()
	on branchNoiseScale changed val do
		updateTrunk()
	on branchNoiseSeed changed val do
		updateTrunk()
	on rotOffset changed val do
		updateTrunk()
	on tiltAmount changed val do
		updateTrunk()
	on tiltVariation changed val do
		updateTrunk()
	on branchTwist changed val do
		updateTrunk()
	on branchRadius changed val do
		updateTrunk()
	on branchPinchCurve changed val do
		updateTrunk()
	on branchSides changed val do
		updateTrunk()
	on branchUVScale changed val do
		updateTrunk()
	on branchStretch changed val do
		updateTrunk()
	on leavesPerBranch changed val do
		updateTrunk()
	on leafRotStep changed val do
		updateTrunk()
	on leafRotVariation changed val do
		updateTrunk()
	on LeafTilt changed val do
		updateTrunk()
	on LeafTiltVariation changed val do
		updateTrunk()
	on leafScaleVariation changed val do
		updateTrunk()
	on leafScale changed val do
		updateTrunk()
	on leafBunch changed val do
		updateTrunk()
	on leafOffset changed val do
		updateTrunk()
	on btn_bakeTree pressed do
	(
		bakeTree()
		for i = 1 to 40 do treegen.controls[i].enabled = false
		btn_hideTrunk.enabled = false
		btn_hideBranches.enabled = false
		btn_hideLeaves.enabled = false
		btn_bakeTree.enabled = false
		btn_generateTree.enabled = true
		canEdit = false
	)
	on btn_addSelection pressed do
	(
		for i in selection do
		(
			if superclassof i != geometryclass then messagebox (i.name as string + " needs to be a geometry object... clearly it is not. Pull yourself together, dude")
			else
			(
			leavesArray = #()
			leavesArray = for i in selection collect i
			lb_leafBranches.items = for i in leavesArray collect  i.name
			if canEdit == true do for i = 32 to 40 do treegen.controls[i].enabled = true
			)
		)
		if canEdit == true do updateTrunk()
	)
	on btn_clearSelection pressed do
	(
		leavesArray = #()
		lb_leafBranches.items = #()
		for i = 32 to 40 do treegen.controls[i].enabled = false
		if canEdit == true do updateTrunk()
	)
	on btn_generateTree pressed do
	(
		canEdit = true
		updateTrunk()
		for i = 1 to 31 do treegen.controls[i].enabled = true
		TreeGen.btn_generateTree.enabled = false
		btn_hideTrunk.enabled = true
		btn_hideBranches.enabled = true
		btn_hideLeaves.enabled = true
		btn_bakeTree.enabled = true
		
		if treeGen.lb_leafBranches.items[1] != undefined then for i = 32 to 40 do treegen.controls[i].enabled = true
			
		
	)
	on btn_hideTrunk pressed do
	(
		hide trunkMesh
	)
	on btn_hideBranches pressed do
	(
		hide branchmesharray
	)
	on btn_hideLeaves pressed do
	(
		hide leafmesharray
	)
	on btn_BarkMaterial picked mtl do
	(
		updateTrunk()
	)
)

createDialog TreeGen

)