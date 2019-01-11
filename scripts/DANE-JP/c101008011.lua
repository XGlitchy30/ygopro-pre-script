--バスター・スナイパー
--
--Script by mercury233
function c101008011.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101008011,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,101008011)
	e1:SetCost(c101008011.spcost)
	e1:SetTarget(c101008011.sptg)
	e1:SetOperation(c101008011.spop)
	c:RegisterEffect(e1)
	--change race and attr
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101008011,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101008011+100)
	e2:SetTarget(c101008011.chtg)
	e2:SetOperation(c101008011.chop)
	c:RegisterEffect(e2)
end
c101008011.card_code_list={80280737}
function c101008011.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c101008011.spfilter(c,e,tp)
	return aux.IsCodeListed(c,80280737) and not c:IsCode(101008011) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101008011.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(c101008011.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end 
function c101008011.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101008011.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101008011.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101008011.splimit(e,c)
	return not c:IsType(TYPE_SYNCHRO) and c:IsLocation(LOCATION_EXTRA)
end
function c101008011.filter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c101008011.cfilter,tp,LOCATION_EXTRA,0,1,nil,c)
end
function c101008011.cfilter(c,tc)
	return c:IsType(TYPE_SYNCHRO) and (not c:IsRace(tc:GetRace()) or not c:IsAttribute(tc:GetAttribute()))
end
function c101008011.chtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101008011.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c101008011.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c101008011.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function c101008011.chop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local cg=Duel.SelectMatchingCard(tp,c101008011.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,tc)
	if cg:GetCount()==0 then return end
	Duel.ConfirmCards(1-tp,cg)
	local ec=cg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e1:SetValue(ec:GetRace())
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(ec:GetAttribute())
	tc:RegisterEffect(e2)
end
