export type ClaimRewardResponse = {
	day: number,
	reward: {
		id: number,
		type: string,
		quantity: number,
	},
	next_claim_at: string,
}

export type LastClaimResponse = {
	day: number,
	can_claim: boolean,
	next_claim_at: string,
}

export type RewardsResponse = {
	{
		day: number,
		item_id: number,
		quantity: number,
	}
}

return {}
