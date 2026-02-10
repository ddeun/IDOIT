function handleBoardType() {
    const btype = document.getElementById("btype");
    const anonChk = document.getElementById("anonymous");

    if (!btype || !anonChk) return;

    if (btype.value === "ANON") {
        anonChk.checked = true;
        anonChk.disabled = true;
    } else {
        anonChk.disabled = false;
    }
}
