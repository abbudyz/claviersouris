-- Keyboard (MSI, full size) + Mouse, together in one scene - 3ds Max 2025
-- Keyboard: grey-blue case, 104-style keys (main block, nav cluster, numpad),
--           3 green LEDs, "MSI" logo, black cable.
-- Mouse:    cyan smooth rounded body, scroll wheel, button split line.
-- Run: Scripting > Run Script...   then File > Save As .max
-- Press F4 in the viewport to see Edged Faces.

(
    -- ===== Placement (cm) =====
    local kx = -22.75        -- keyboard front-left corner X
    local ky = -45.0         -- keyboard front-left corner Y
    local mx = 38.0          -- mouse centre X
    local my = -38.0         -- mouse centre Y

    -- ===== Keyboard parameters =====
    local pitch = 1.9        -- key pitch (1u)
    local keyGap = 0.15
    local keyH = 1.1
    local caseH = 2.0
    local xOff = 0.9         -- left margin of keys inside the case
    local yOff = 2.0         -- front margin (palm rest)
    local caseW = 23 * pitch + 2 * xOff
    local caseD = 6.5 * pitch + yOff + 0.8

    local caseC = color 175 190 210
    local keyC  = color 212 222 237
    local ledC  = color 150 235 20
    local cableC = color 30 30 35
    local mouseC = color 80 225 215
    local darkC  = color 45 45 55

    fn mat o col nm =
    (
        o.name = nm
        o.wirecolor = col
        o.material = StandardMaterial diffuse:col name:(nm + "_mat")
        o
    )

    fn rep n w =
    (
        local a = #()
        for i = 1 to n do append a w
        a
    )

    local kbParts = #()
    local keyList = #()

    -- ===== Case =====
    local cs = ChamferBox width:caseW length:caseD height:caseH fillet:0.5 filletsegs:2 pos:[kx + caseW / 2.0, ky + caseD / 2.0, 0]
    mat cs caseC "Keyboard_Case"
    convertToPoly cs
    append kbParts cs

    -- ===== Key helpers =====
    fn addKey xu yu wu hu =
    (
        local k = ChamferBox width:(wu * pitch - keyGap) length:(hu * pitch - keyGap) height:keyH fillet:0.15 filletsegs:1 pos:[kx + xOff + (xu + wu / 2.0) * pitch, ky + yOff + (yu + hu / 2.0) * pitch, caseH]
        convertToPoly k
        append keyList k
    )

    fn addRow xu yu widths =
    (
        local cx = xu
        for w in widths do
        (
            if w < 0 then
            (
                cx += (-w)
            )
            else
            (
                addKey cx yu w 1.0
                cx += w
            )
        )
    )

    -- ===== Main block (rows from front to back) =====
    addRow 0 0 #(1.25, 1.25, 1.25, 6.25, 1.25, 1.25, 1.25, 1.25)
    addRow 0 1 (#(2.25) + (rep 10 1.0) + #(2.75))
    addRow 0 2 (#(1.75) + (rep 11 1.0) + #(2.25))
    addRow 0 3 (#(1.5) + (rep 12 1.0) + #(1.5))
    addRow 0 4 ((rep 13 1.0) + #(2.0))
    addRow 0 5.5 #(1, -1, 1, 1, 1, 1, -0.5, 1, 1, 1, 1, -0.5, 1, 1, 1, 1)

    -- ===== Navigation cluster =====
    addRow 15.5 5.5 #(1, 1, 1)
    addRow 15.5 4 #(1, 1, 1)
    addRow 15.5 3 #(1, 1, 1)
    addRow 15.5 1 #(-1, 1)
    addRow 15.5 0 #(1, 1, 1)

    -- ===== Numpad =====
    addRow 19 4 #(1, 1, 1, 1)
    addRow 19 3 #(1, 1, 1)
    addRow 19 2 #(1, 1, 1)
    addRow 19 1 #(1, 1, 1)
    addKey 22 2 1.0 2.0      -- tall "+"
    addKey 22 0 1.0 2.0      -- tall "Enter"
    addKey 19 0 2.0 1.0      -- "0"
    addKey 21 0 1.0 1.0      -- "."

    -- merge all keys into one editable poly object
    local keysObj = keyList[1]
    for i = 2 to keyList.count do polyop.attach keysObj keyList[i]
    mat keysObj keyC "Keyboard_Keys"
    append kbParts keysObj

    -- ===== Green LEDs =====
    for k = 1 to 3 do
    (
        local lxu = 18.7 + k * 1.3
        local led = Box width:1.2 length:0.45 height:0.15 pos:[kx + xOff + lxu * pitch, ky + yOff + 6.0 * pitch, caseH]
        mat led ledC ("Keyboard_LED_" + (k as string))
        convertToPoly led
        append kbParts led
    )

    -- ===== MSI logo =====
    local logo = Text text:"MSI" size:2.4
    addModifier logo (Extrude amount:0.25)
    mat logo (color 150 165 190) "Keyboard_Logo"
    convertToPoly logo
    logo.pos = [kx + 5.0, ky + 0.7, caseH]
    append kbParts logo

    -- ===== Cable =====
    local cab = SplineShape name:"Keyboard_Cable" wirecolor:cableC
    local sp = addNewSpline cab
    addKnot cab sp #smooth #curve [kx + 16.0, ky + caseD - 0.3, 1.0]
    addKnot cab sp #smooth #curve [kx + 16.0, ky + caseD + 6.0, 0.4]
    addKnot cab sp #smooth #curve [kx + 8.0, ky + caseD + 14.0, 0.25]
    addKnot cab sp #smooth #curve [kx + 12.0, ky + caseD + 24.0, 0.25]
    addKnot cab sp #smooth #curve [kx + 24.0, ky + caseD + 30.0, 0.25]
    updateShape cab
    cab.render_displayRenderMesh = true
    cab.render_thickness = 0.5
    cab.render_sides = 8
    append kbParts cab

    local kbGrp = group kbParts name:"Keyboard"
    kbGrp.pivot = [kx + caseW / 2.0, ky + caseD / 2.0, 0]

    -- ===== MOUSE =====
    local mouseParts = #()

    local body = ChamferBox width:6.5 length:11.0 height:3.6 fillet:1.6 filletsegs:4 widthsegs:4 lengthsegs:6 heightsegs:2 pos:[mx, my, 0]
    mat body mouseC "Mouse_Body"
    convertToPoly body
    append mouseParts body

    local wheel = ChamferBox width:0.8 length:1.8 height:0.5 fillet:0.2 filletsegs:1 pos:[mx, my + 2.6, 3.45]
    mat wheel darkC "Mouse_Wheel"
    convertToPoly wheel
    append mouseParts wheel

    local splitLine = Box width:0.12 length:3.6 height:0.1 pos:[mx, my + 3.4, 3.55]
    mat splitLine darkC "Mouse_ButtonSplit"
    convertToPoly splitLine
    append mouseParts splitLine

    local mGrp = group mouseParts name:"Mouse"
    mGrp.pivot = [mx, my, 0]

    select #(kbGrp, mGrp)
    max zoomext sel all
    format "Keyboard and mouse created.\n"
)
